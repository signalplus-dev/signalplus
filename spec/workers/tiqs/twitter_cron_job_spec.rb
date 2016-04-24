require 'rails_helper'

describe TwitterCronJob do
  let(:last_occurrence)    { 2.minutes.ago.to_i }
  let(:current_occurrence) { Time.now.to_i }
  let(:worker)             { described_class.new() }
  let(:brand)              { create(:brand) }

  it 'calls on Twitter listener' do
    brand
    expect(Responders::Twitter::Listener).to receive(:process_messages)
    worker.perform(last_occurrence, current_occurrence)
  end
end
