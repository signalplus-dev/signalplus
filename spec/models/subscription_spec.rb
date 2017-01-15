# == Schema Information
#
# Table name: subscriptions
#
#  id                     :integer          not null, primary key
#  brand_id               :integer
#  subscription_plan_id   :integer
#  provider               :string
#  token                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  canceled_at            :datetime
#  trial_end              :datetime
#  trial                  :boolean          default(TRUE)
#  deleted_at             :datetime
#  lock_version           :integer          default(0)
#  will_be_deactivated_at :datetime
#

require 'rails_helper'
require 'shared/stripe'

describe Subscription do
  context 'with stripe setup' do
    include_context 'stripe setup'

    describe '.subscribe' do
      it 'raises an error when trying to create a subscription with an admin plan' do
        expect {
          described_class.subscribe!(brand, admin_plan, user.email, stripe_token)
        }.to raise_error(Subscription::InvalidPlan)
      end

      it 'creates a payment handler' do
        expect {
          described_class.subscribe!(brand, basic_plan, user.email, stripe_token)
        }.to change {
          PaymentHandler.count
        }.from(0).to(1)
      end

      it 'creates a subscription' do
        expect {
          described_class.subscribe!(brand, basic_plan, user.email, stripe_token)
        }.to change {
          described_class.count
        }.from(0).to(1)
      end

      it 'should be on a trial' do
        described_class.subscribe!(brand, basic_plan, user.email, stripe_token)
        expect(Subscription.first.trial).to be_truthy
      end
    end

    describe '.resubscribe!' do
      before do
        allow(described_class)
          .to receive(:create_stripe_subscription!)
          .and_return(resubscribed_stripe_subscription)
      end

      it 'should resubscribe the user to a subscription' do
        expect {
          described_class.resubscribe!(brand.reload, new_plan)
        }.to change {
          Subscription.count
        }.from(0).to(1)
      end

      it 'should have no trial_end' do
        subscription = described_class.resubscribe!(brand.reload, new_plan)
        expect(subscription.trial_end).to be_nil
      end

      it 'should not pass the trial_end to the stripe subscription' do
        expect(Subscription).to receive(:create_stripe_subscription!).with(
          a_kind_of(String),
          a_kind_of(String),
        )
        subscription = described_class.resubscribe!(brand.reload, new_plan)
      end
    end

    context 'a brand already subscribed to a plan' do
      include_context 'brand already subscribed to plan'

      describe '#update_plan!' do
        context 'with and admin plan' do
          it 'should not allow updating to an admin plan' do
            expect { subscription.update_plan!(admin_plan) }.to raise_error(Subscription::InvalidPlan)
          end
        end

        context 'with an active subscription' do
          it 'changes the subscription_plan' do
            expect {
              subscription.update_plan!(advanced_plan)
            }.to change {
              subscription.subscription_plan
            }.from(basic_plan).to(advanced_plan)
          end

          it 'logs the changes' do
            with_versioning do
              expect {
                subscription.update_plan!(advanced_plan)
              }.to change {
                subscription.versions.count
              }.from(0).to(1)
            end
          end

          context 'downgrading a plan' do
            before { subscription.update_plan!(advanced_plan) }

            context 'with less than the limit of the plan' do
              before { allow(subscription).to receive(:monthly_response_count).and_return(4999) }

              it 'should allow downgrading the plan' do
                expect { subscription.update_plan!(basic_plan) }.to_not raise_error
              end
            end

            context 'with exactly the limit of the plan' do
              before { allow(subscription).to receive(:monthly_response_count).and_return(5000) }

              it 'should allow downgrading the plan' do
                expect { subscription.update_plan!(basic_plan) }.to_not raise_error
              end
            end

            context 'with more than the limit of the plan' do
              before { allow(subscription).to receive(:monthly_response_count).and_return(5001) }

              it 'should not allow downgrading the plan' do
                expect {
                  subscription.update_plan!(basic_plan)
                }.to raise_error(Subscription::InvalidPlanUpdate)
              end
            end
          end
        end

        context 'with a deactivated subscription' do
          before do
            brand.update!(subscription: subscription)
            allow(subscription).to receive(:deactivated?).and_return(true)
            allow(described_class)
              .to receive(:create_stripe_subscription!)
              .and_return(resubscribed_stripe_subscription)
          end

          it 'destroys the original subscription' do
            expect {
              subscription.update_plan!(basic_plan)
            }.to change {
              subscription.deleted_at?
            }.from(false).to(true)
          end

          it 'changes the subscription of the brand' do
            new_subscription = nil

            expect {
              subscription.update_plan!(basic_plan)
            }.to change {
              brand.reload.subscription.id
            }.from(subscription.id)
          end
        end
      end

      describe '.end_trial!' do
        before do
          subscription.update!(token: nil, trial: true)
        end

        it 'ends the trial' do
          expect {
            subscription.end_trial!
          }.to change {
            subscription.reload.trial?
          }.from(true).to(false)
        end

        it 'adds a subscription' do
          expect {
            subscription.end_trial!
          }.to change {
            subscription.reload.token
          }.from(nil).to(a_kind_of(String))
        end
      end

      describe '.cancel_plan!' do
        let(:cancel_stripe_subscription!) do
          stripe_response = nil

          VCR.use_cassette('cancel_stripe_subscription') do
            stripe_response = subscription.stripe_subscription.delete
          end

          stripe_response
        end

        let(:mock_stripe_subscription) do
          double(
            :stripe_subscription,
            canceled_at: Time.current,
            current_period_end: 14.days.from_now
          )
        end

        before do
          allow(subscription).to receive(:cancel_stripe_subscription!).and_return(cancel_stripe_subscription!)
          allow(subscription).to receive(:stripe_subscription).and_return(mock_stripe_subscription)
        end

        it 'cancels the subscription' do
          expect {
            subscription.cancel_plan!
          }.to change {
            subscription.canceled?
          }.from(false).to(true)
        end

        it 'logs the changes' do
          with_versioning do
            expect {
              subscription.cancel_plan!
            }.to change {
              subscription.versions.count
            }.from(0).to(1)
          end
        end
      end
    end

    describe '#deactivated' do
      subject { create(:subscription) }
      it { is_expected.to_not be_deactivated }
      its(:will_be_deactivated_at) { is_expected.to be_nil }

      context 'setting a deactivated date in the future' do
        before { subject.will_be_deactivated_at = 1.day.from_now }
        it { is_expected.to_not be_deactivated }
      end

      context 'setting a deactivated date in the past' do
        before { subject.will_be_deactivated_at = 1.day.ago }
        it { is_expected.to be_deactivated }
      end
    end

    describe '#resubscribe_and_destroy!' do
      subject { create(:subscription, brand: brand) }

      before { expect(subject).to receive(:destroy!) }

      context 'in a trial' do
        before { subject.trial = true }

        context 'with a future trial_end' do
          let(:trial_end) { 1.day.from_now }

          before { allow(subject).to receive(:trial_end).and_return(trial_end) }

          it 'should pass in trial_end as an argument to .resubscribe!' do
            expect(Subscription).to receive(:resubscribe!).with(
              brand,
              basic_plan
            )
            subject.send(:resubscribe_and_destroy!, basic_plan)
          end
        end

        # Note: this is highly unlikely but writing a test for it anyway
        context 'with past trial_end' do
          let(:trial_end) { 1.day.ago }

          before { allow(subject).to receive(:trial_end).and_return(trial_end) }

          it 'should not pass in trial_end as an argument to .resubscribe!' do
            expect(Subscription).to receive(:resubscribe!).with(
              brand,
              basic_plan
            )
            subject.send(:resubscribe_and_destroy!, basic_plan)
          end
        end
      end

      context 'not in a trial' do
        before { subject.trial = false }

        context 'with a future trial_end' do
          let(:trial_end) { 1.day.from_now }

          before { allow(subject).to receive(:trial_end).and_return(trial_end) }

          it 'should not pass in trial_end as an argument to .resubscribe!' do
            expect(Subscription).to receive(:resubscribe!).with(
              brand,
              basic_plan
            )
            subject.send(:resubscribe_and_destroy!, basic_plan)
          end
        end

        context 'with a past trial_end' do
          let(:trial_end) { 1.day.ago }

          before { allow(subject).to receive(:trial_end).and_return(trial_end) }

          it 'should not pass in trial_end as an argument to .resubscribe!' do
            expect(Subscription).to receive(:resubscribe!).with(
              brand,
              basic_plan
            )
            subject.send(:resubscribe_and_destroy!, basic_plan)
          end
        end
      end
    end
  end

  describe '.passed_trial' do
    let!(:passed_trial)              { create(:subscription, :passed_trial) }
    let!(:not_on_trial)              { create(:subscription, :not_on_trial) }
    let!(:passed_trial_not_on_trial) { create(:subscription, :passed_trial, :not_on_trial) }

    subject { described_class.passed_trial }

    its(:length) { is_expected.to eq(1) }
    its(:first)  { is_expected.to eq(passed_trial) }
  end
end
