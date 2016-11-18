require 'rails_helper'

describe EmailSubscriptionWorker do
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
    worker.perform(user.id)

    expect(mock_client).to have_received(:lists).with(list_id)
    expect(mock_client).to have_received(:members).with(encrypted_email)
    expect(mock_client).to have_received(:upsert).with(
      body: {
        email_address: user.email,
        status: 'subscribed',
        merge_fields: {
          FNAME: user.brand.name,
          LNAME: user.name
        }
      }
    )
  end
end
