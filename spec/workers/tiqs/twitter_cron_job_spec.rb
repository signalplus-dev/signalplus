require 'rails_helper'

describe TwitterCronJob do
  let(:last_occurrence)    { 2.minutes.ago.to_i }
  let(:current_occurrence) { Time.now.to_i }
  let(:worker)             { described_class.new() }
  let(:brand)              { create(:brand, polling_tweets: true) }

  it 'calls on Twitter listener' do
    expect(Responders::Twitter::Listener)
      .to receive_message_chain(:delay, :process_messages).with(brand.id)
    worker.perform(last_occurrence, current_occurrence)
  end
end
