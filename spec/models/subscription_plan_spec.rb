# == Schema Information
#
# Table name: subscription_plans
#
#  id                 :integer          not null, primary key
#  amount             :integer
#  name               :string
#  number_of_messages :integer
#  currency           :string
#  provider           :string
#  provider_id        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :string           default("")
#  reference          :string           not null
#

require 'rails_helper'

describe SubscriptionPlan do
  let(:basic_plan)    { SubscriptionPlan.basic }
  let(:advanced_plan) { SubscriptionPlan.advanced }
  let(:premium_plan)  { SubscriptionPlan.premium }
  let(:admin_plan)    { SubscriptionPlan.admin }

  describe '#{plan_name}?' do
    describe '#basic?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to be_basic }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to_not be_basic }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to_not be_basic }
      end

      context 'admin plan' do
        subject { admin_plan }
        it { is_expected.to_not be_basic }
      end
    end

    describe '#advanced?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to_not be_advanced }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to be_advanced }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to_not be_advanced }
      end

      context 'admin plan' do
        subject { admin_plan }
        it { is_expected.to_not be_advanced }
      end
    end

    describe '#premium?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to_not be_premium }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to_not be_premium }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to be_premium }
      end

      context 'admin plan' do
        subject { admin_plan }
        it { is_expected.to_not be_premium }
      end
    end

    describe '#admin?' do
      context 'basic plan' do
        subject { basic_plan }
        it { is_expected.to_not be_admin }
      end

      context 'advanced plan' do
        subject { advanced_plan }
        it { is_expected.to_not be_admin }
      end

      context 'premium plan' do
        subject { premium_plan }
        it { is_expected.to_not be_admin }
      end

      context 'admin plan' do
        subject { admin_plan }
        it { is_expected.to be_admin }
      end
    end
  end
end
