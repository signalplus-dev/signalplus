require 'rails_helper'

describe Email::Subscription do
  let(:user) { create(:user) }
  let(:fake_list_id) { '111' }

  before { 
    allow(ENV).to receive(:[]).and_return(nil)
    allow(ENV).to receive(:[]).with('MAILCHIMP_NEWSLETTER_LIST_ID').and_return(fake_list_id) 
  }
  
  subject { described_class.new(user) }

  describe '#subscribe' do
    it 'calls EmailSubscriptionWorker' do
      expect(EmailSubscriptionWorker).to receive(:perform_async).with(
        user.id, fake_list_id, subject.encrypted_email
      )

      subject.subscribe
    end
  end

  describe '#unsubscribe' do
    it 'calls EmailRemoveSubscriptionWorker' do
      expect(EmailRemoveSubscriptionWorker).to receive(:perform_async).with(
        fake_list_id, subject.encrypted_email
      )

      subject.unsubscribe
    end
  end
end
