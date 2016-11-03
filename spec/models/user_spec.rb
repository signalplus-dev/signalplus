# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  brand_id               :integer
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  tokens                 :json
#  email_subscription     :boolean          default(FALSE)
#

require 'rails_helper'

describe User do
  let(:identity)              { create(:identity) }
  let(:brand)                 { create(:brand) }
  let(:subscription_worker)   { EmailSubscriptionWorker }
  let(:unsubscription_worker) { EmailRemoveSubscriptionWorker }

  context 'with an unsubscribed user' do
    let(:new_email)  { 'updated_email@signal.com' }
    let(:user)       { create(:user, email_subscription: false) }


    it 'runs callback' do
      expect(EmailSubscriptionWorker).to receive(:perform_async).with(user.id)

      user.run_callbacks(:save)

    end

    context 'unsubscribe from newsletter' do
      it 'updates user email info without calling workers' do
        expect(user).not_to receive(:unsubscribe_from_newsletter)
        expect(user).not_to receive(:subscribe_to_newsletter)
        expect(user).to receive(:handle_subscription)

        user.update!(email: new_email, email_subscription: false)

        expect(user.email).to eq(new_email)
        expect(user.email_subscription).to be_falsey
      end
    end

    context 'subscribe to newsletter' do
      it 'updates user email info while subscribing user' do
        expect(user).not_to receive(:unsubscribe_from_newsletter)
        expect(user).to receive(:subscribe_to_newsletter)
        expect(user).to receive(:handle_subscription)
        expect(EmailSubscriptionWorker).to receive(:perform_async)

        user.update!(email: new_email, email_subscription: true)

        expect(user.email).to eq(new_email)
        expect(user.email_subscription).to be_truthy
      end
    end
  end

  # context 'subscribes to newsletter' do
  #   it 'update user email info' do
  #     expect(user).to receive(:subscribe_to_newsletter)
  #     expect(subscription_worker).to receive(:perform_async).once.with(user.id)
  #     expect(unsubscription_worker).to receive(:perform_async).once.with(user.previous_encrypted_email)

  #     user.update!(email: new_email, email_subscription: true)

  #     expect(user.email).to eq(new_email)
  #     expect(user.email_subscription).to be_truthy
  #   end

  #   it 'unsubscribes old email address' do
  #     expect_any_instance_of(email_service).to receive(:unsubscribe)

  #     user.update_email_info!(new_email, true)
  #   end

  #   it 'subscribes new email address' do

  #     expect(user).to receive(:subscribe_to_newsletter)
  #     expect(subscription_worker).not_to receive(:perform_async).with(user.previous_encrypted_email)

  #     user.update!(email_subscription: false)

  #     expect_any_instance_of(email_service).to receive(:subscribe)

  #     user.update_email_info!(new_email, true)
  #   end
  # end

end
