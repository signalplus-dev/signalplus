require 'rails_helper'
require 'shared/stripe'

describe InvoiceHandler do
  before(:all) { StripeMock.start }
  after(:all) { StripeMock.stop }

  describe '#create_invoice!' do
    let(:brand) { create(:brand) }
    let(:user) { create(:user, brand: brand) }
    let(:event) { StripeMock.mock_webhook_event('invoice.created') }

    subject { described_class.new(event) }

    it 'creates an invoice object with a valid email' do
      expect {
        allow_any_instance_of(InvoiceHandler).to receive(:get_brand).and_return(brand)

        subject.create_invoice!
      }.to change {
        user.brand.invoices.count
      }.to eq(1)
    end

    it 'raises error with invalid email' do
      expect {
        subject.create_invoice!
      }.not_to change {
        user.brand.invoices.count
      }
    end
  end

  describe '#update_invoice_paid_timestamp!' do
    let(:brand) { create(:brand) }
    let(:invoice) { create(:invoice, :unpaid) }
    let(:event) { StripeMock.mock_webhook_event('invoice.payment_succeeded') }

    subject { described_class.new(event) }

    it 'updates invoice paid_at attribute' do
      allow(Invoice).to receive(:find).and_return(invoice)

      timestamp = Time.at(event.data.object.date).to_formatted_s(:db)
      subject.update_invoice_paid_timestamp!
      expect(invoice.paid_at).to eq(timestamp)
    end

    it 'does not update invoice if not found' do
      subject.update_invoice_paid_timestamp! 
      expect(invoice.paid_at).to be(nil)
    end
  end
end

