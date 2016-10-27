require 'rails_helper'
require 'shared/stripe'

describe InvoiceHandler do
  before(:all) { StripeMock.start }
  after(:all) { StripeMock.stop }

  describe '#create_invoice' do
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
end

