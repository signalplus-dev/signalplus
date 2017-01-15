require 'rails_helper'
require 'shared/stripe'

describe InvoiceAdjustmentHandler  do
  include_context 'upgrade plan'
  let(:invoice) { Invoice.first }

  let(:handler) { described_class.new(brand, basic_plan, advanced_plan) }

  let(:upcoming_invoice_items) do
    stripe_response = nil

    VCR.use_cassette('upcoming_invoice_items') do
      stripe_response = handler.send(:upcoming_invoice_items)
    end

    stripe_response
  end

  let(:advanced_upgrade_invoice_item) do
    stripe_response = nil

    VCR.use_cassette('create_invoice_item') do
      stripe_response = handler.send(:create_stripe_invoice_item!)
    end

    stripe_response
  end

  context 'upgrading with no upcoming prorations' do
    # Update the subscription and set up the stubs
    before do
      expect(InvoiceAdjustmentWorker).to receive(:perform_in).with(
        anything,
        brand.id,
        basic_plan.id,
        advanced_plan.id
      )
      subscription.update_plan!(advanced_plan)
      allow(handler).to receive(:upcoming_invoice_items)
        .and_return(upcoming_invoice_items)
      allow(handler).to receive(:create_stripe_invoice_item!)
        .and_return(advanced_upgrade_invoice_item)
    end

    it 'should not try to delete line items' do
      expect(Stripe::InvoiceItem).to_not receive(:retrieve)
      handler.adjust!
    end

    it 'should create an invoice adjustment' do
      expect { handler.adjust! }.to change { InvoiceAdjustment.count }.from(0).to(1)
    end

    it 'should create an invoice adjustment of $20.00' do
      handler.adjust!
      amount_originally_paid = invoice.subscription_line_item.amount
      amount_should_pay = (advanced_plan.amount * invoice.proration_ratio).round
      expect(InvoiceAdjustment.last.amount).to eq(
        amount_should_pay - amount_originally_paid
      )
    end

    context 'upgrading to premium' do
      let(:premium_handler) { described_class.new(brand, advanced_plan, premium_plan) }

      let(:upgrade_to_premium) do
        stripe_response = nil

        VCR.use_cassette('upgrade_to_premium') do
          allow(subscription).to receive(:trialing?).and_return(false)
          stripe_response = subscription.send(:update_stripe_subscription!, premium_plan)
        end

        stripe_response
      end

      let(:upcoming_invoice_items_2) do
        stripe_response = nil

        VCR.use_cassette('upcoming_invoice_items_2') do
          stripe_response = premium_handler.send(:upcoming_invoice_items)
        end

        stripe_response
      end

      let(:premium_upgrade_invoice_item) do
        stripe_response = nil

        VCR.use_cassette('create_invoice_item_2') do
          stripe_response = premium_handler.send(:create_stripe_invoice_item!)
        end

        stripe_response
      end

      before do
        handler.adjust!
        # Don't check expection again
        allow(subscription).to receive(:kickoff_invoice_adjustment_worker)

        # Unstub previous test stubs
        Subscription.any_instance.unstub(:stripe_subscription)
        Subscription.any_instance.unstub(:update_stripe_subscription!)

        allow(subscription)
          .to receive(:stripe_subscription).and_return(upgrade_to_advanced)
        allow(subscription)
          .to receive(:update_stripe_subscription!).and_return(upgrade_to_premium)

        # Update plan
        subscription.update_plan!(premium_plan)

        allow(premium_handler).to receive(:upcoming_invoice_items)
          .and_return(upcoming_invoice_items_2)
        allow(premium_handler).to receive(:create_stripe_invoice_item!)
          .and_return(premium_upgrade_invoice_item)
      end

      it 'should not try to delete line items' do
        expect(Stripe::InvoiceItem).to_not receive(:retrieve)
        premium_handler.adjust!
      end

      it 'should create an invoice adjustment' do
        expect { premium_handler.adjust! }.to change { InvoiceAdjustment.count }.from(1).to(2)
      end

      it 'should create an invoice adjustment of $20.00' do
        premium_handler.adjust!
        amount_originally_paid = invoice.subscription_line_item.amount
        amount_should_pay = (premium_plan.amount * invoice.proration_ratio).round
        expect(InvoiceAdjustment.last.amount).to eq(
          amount_should_pay - (amount_originally_paid + InvoiceAdjustment.first.amount)
        )
      end

      context 'downgrading and then upgrading' do
        let(:handler_with_prorations) { described_class.new(brand, basic_plan, premium_plan) }

        let(:downgrade_to_basic) do
          stripe_response = nil

          VCR.use_cassette('downgrade_to_basic') do
            allow(subscription).to receive(:trialing?).and_return(false)
            allow(subscription).to receive(:downgrading?).and_return(true)
            stripe_response = subscription.send(:update_stripe_subscription!, basic_plan)
          end

          stripe_response
        end

        let(:upgrade_after_downgrade) do
          stripe_response = nil

          VCR.use_cassette('upgrade_after_downgrade') do
            allow(subscription).to receive(:trialing?).and_return(false)
            allow(subscription).to receive(:downgrading?).and_return(false)
            stripe_response = subscription.send(:update_stripe_subscription!, premium_plan)
          end

          stripe_response
        end

        let(:invoice_items_with_prorations) do
          stripe_response = nil

          VCR.use_cassette('upcoming_invoice_items_3') do
            stripe_response = handler_with_prorations.send(:upcoming_invoice_items)
          end

          stripe_response
        end

        before do
          premium_handler.adjust!

          subscription.unstub(:stripe_subscription)
          subscription.unstub(:update_stripe_subscription!)

          allow(subscription)
            .to receive(:stripe_subscription).and_return(upgrade_to_premium)
          allow(subscription)
            .to receive(:update_stripe_subscription!).and_return(downgrade_to_basic)

          # Downgrade plan
          subscription.update_plan!(basic_plan)

          subscription.unstub(:stripe_subscription)
          subscription.unstub(:update_stripe_subscription!)

          allow(subscription)
            .to receive(:stripe_subscription).and_return(downgrade_to_basic)
          allow(subscription)
            .to receive(:update_stripe_subscription!).and_return(upgrade_after_downgrade)

          # Upgrade plan again
          subscription.update_plan!(premium_plan)

          allow(handler_with_prorations).to receive(:upcoming_invoice_items)
            .and_return(invoice_items_with_prorations)

          mock = double(:stripe_invoice_item, delete: nil)
          expect(Stripe::InvoiceItem).to receive(:retrieve).twice.and_return(mock)
        end

        it 'should not create an invoice adjustment' do
          expect { handler_with_prorations.adjust! }.to_not change { InvoiceAdjustment.count }.from(2)
        end

        it 'should not try to create an adjustment on Stripe' do
          expect(handler_with_prorations).to_not receive(:create_stripe_invoice_item!)
          handler_with_prorations.adjust!
        end
      end
    end
  end
end
