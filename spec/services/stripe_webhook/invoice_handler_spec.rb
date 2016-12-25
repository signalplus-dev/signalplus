require 'rails_helper'
require 'shared/stripe'

describe StripeWebhook::InvoiceHandler do
  before(:all) { StripeMock.start }
  after(:all)  { StripeMock.stop }

  describe '#create_invoice!' do
    let(:brand) { create(:brand) }
    let(:user)  { create(:user, brand: brand) }
    let(:event) { StripeMock.mock_webhook_event('invoice.created') }


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

  describe '#update_invoice_paid_timestamp!' do
    let(:brand)        { create(:brand) }
    let(:invoice)      { create(:invoice, :unpaid) }
    let(:event)        { StripeMock.mock_webhook_event('invoice.payment_succeeded') }
    let(:invoice_data) { event.data.object }

    subject { described_class.new(event) }

    it 'updates invoice paid_at attribute' do
      allow(Invoice).to receive(:find_by).and_return(invoice)

      timestamp = Time.at(invoice_data.date).to_formatted_s(:db)
      subject.payment_succeeded
      expect(invoice.paid_at).to eq(timestamp)
    end

    it 'does not update invoice if not found' do
      subject.payment_succeeded
      expect(invoice.paid_at).to be(nil)
    end
  end
end

