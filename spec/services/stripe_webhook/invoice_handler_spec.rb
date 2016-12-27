require 'rails_helper'
require 'shared/stripe'

shared_context 'setup created invoice' do
  let(:brand) { create(:brand) }
  let(:user)  { create(:user, brand: brand) }
  let(:event) { StripeMock.mock_webhook_event('invoice.created') }
end

shared_context 'create invoice' do
  include_context 'setup created invoice'

  before do
    allow_any_instance_of(described_class).to receive(:get_brand_id).and_return(brand.id)
    described_class.new(event).created
  end
end

describe StripeWebhook::InvoiceHandler do
  before { StripeMock.start }
  after  { StripeMock.stop }

  describe '#created' do
    include_context 'setup created invoice'

    subject { described_class.new(event) }

    it 'creates an invoice object with a valid email' do
      allow_any_instance_of(described_class).to receive(:get_brand_id).and_return(brand.id)
      expect {
        subject.created
      }.to change {
        user.brand.reload.invoices.count
      }.from(0).to(1)
    end

    it 'raises error with invalid customer' do
      expect { subject.created }.to raise_error(StandardError)
    end
  end

  describe '#payment_succeeded' do
    let(:brand)        { create(:brand) }
    let(:invoice)      { create(:invoice, :unpaid) }
    let(:event)        { StripeMock.mock_webhook_event('invoice.payment_succeeded') }
    let(:invoice_data) { event.data.object }

    subject { described_class.new(event) }

    it 'updates invoice paid_at attribute' do
      allow(Invoice).to receive(:find_by).and_return(invoice)

      timestamp = Time.at(event.created)
      subject.payment_succeeded
      expect(invoice.paid_at).to eq(timestamp)
    end

    it 'does not update invoice if not found' do
      subject.payment_succeeded
      expect(invoice.paid_at).to be(nil)
    end
  end

  describe '#payment_failed' do
    include_context 'create invoice'

    let(:invoice)              { Invoice.first }
    let(:payment_failed_event) { StripeMock.mock_webhook_event('invoice.payment_failed') }

    subject { described_class.new(payment_failed_event) }

    it 'should mark the invoice as failed' do
      expect {
        subject.payment_failed
      }.to change {
        invoice.reload.payment_failed?
      }.from(false).to(true)
    end
  end

  describe '#updated' do
    include_context 'create invoice'

    let(:invoice)       { Invoice.first }
    let(:updated_event) { StripeMock.mock_webhook_event('invoice.updated') }

    subject { described_class.new(updated_event) }

    it 'should update the updated_at' do
      expect { subject.updated }.to change { invoice.reload.updated_at }
    end
  end

  describe '#should_raise_error?' do
    let(:event)   { StripeMock.mock_webhook_event('invoice.created') }
    let(:handler) { described_class.new(event) }

    context 'brand id found' do
      it 'should not raise an error' do
        expect(handler.send(:should_raise_error?, 1)).to be_falsey
      end
    end

    context 'brand id not found' do
      context 'event is in livemode' do
        before { allow(event).to receive(:livemode).and_return(true) }

        context 'Rails env production' do
          before { allow(Rails).to receive_message_chain(:env, :production?).and_return(true) }

          it 'should raise an error' do
            expect(handler.send(:should_raise_error?, nil)).to be_truthy
          end
        end

        context 'Rails env not production' do
          before { allow(Rails).to receive_message_chain(:env, :production?).and_return(false) }

          it 'should raise an error' do
            expect(handler.send(:should_raise_error?, nil)).to be_truthy
          end
        end
      end

      context 'event is not in livemode' do
        before { allow(event).to receive(:livemode).and_return(false) }

        context 'Rails env production' do
          before { allow(Rails).to receive_message_chain(:env, :production?).and_return(true) }

          it 'should not raise an error' do
            expect(handler.send(:should_raise_error?, nil)).to be_falsey
          end
        end

        context 'Rails env not production' do
          before { allow(Rails).to receive_message_chain(:env, :production?).and_return(false) }

          it 'should raise an error' do
            expect(handler.send(:should_raise_error?, nil)).to be_truthy
          end
        end
      end
    end
  end
end

