require 'rails_helper'

describe EmailRemoveSubscriptionWorker do
  let(:brand)            { create(:brand) }
  let(:worker)           { described_class.new }
  let(:user)             { create(:user, brand: brand) }
  let(:list_id)          { '111' }
  let(:encrypted_email)  { user.encrypted_email }
  let(:mock_client)      { object_spy('mock_client') }

  before {
    allow(ENV).to receive(:[]).and_return(list_id)
    allow(Gibbon::Request).to receive(:new).and_return(mock_client)
  }

  it 'subscribes user in MailChimp list' do
    worker.perform(encrypted_email)

    expect(mock_client).to have_received(:lists).with(list_id)
    expect(mock_client).to have_received(:members).with(encrypted_email)
    expect(mock_client).to have_received(:update).with(
      body: { status: 'unsubscribed' }
    )
  end
end
