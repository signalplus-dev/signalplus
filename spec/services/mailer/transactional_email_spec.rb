require 'rails_helper'
require 'shared/stripe'

describe TransactionalEmail do
  describe '#send' do
    let(:brand)         { identity.brand }
    let!(:identity)      { create(:identity) }
    let!(:subscription) { create(:subscription, brand: brand)}

    before do
      allow(Mandrill::API).to receive(:new).and_call_original
      # allow(Mandrill::API).to receive(:new).and_return(Mandrill::API.new('ZuvTfJ5TJHCLvsxvLxOLUA'))
    end

    context 'welcome email' do
      it 'sends welcome email template' do
        VCR.use_cassette 'mandrill_response' do
          response = described_class.welcome(brand).send
          #expect(response.rejected).to be(nil)
        end
      end
    end
  end
end
