require 'rails_helper'

describe TwitterResponseWorker do
  let(:worker)          { described_class.new }
  let(:brand)           { create(:brand) }
  let(:tweet)           { example_twitter_tweet }
  let(:filter)          { Responders::Twitter::Filter.new(brand, tweet) }
  let(:response_hash)   { filter.grouped_responses.first.last.first.as_json }
  let(:client_user)     { double(:user, screen_name: 'SomeBrand') }
  let(:mock_client)     { double(:client, user: client_user) }
  let(:image)           { double(:image_file) }
  let(:image_string_io) { StringIO.new('some_image.png') }
  let(:temp_file)       { Tempfile.new('test.txt') }

  before do
    allow(Brand).to receive(:find_with_trackers).and_return(brand)
    allow(brand).to receive(:twitter_rest_client).and_return(mock_client)
    allow_any_instance_of(TempImage).to receive(:file).and_return(temp_file)
    allow_any_instance_of(TempImage).to receive(:image_string_io).and_return(image_string_io)
    expect(mock_client).to receive(:update_with_media).once.and_return(double(:tweet, id: 100))
  end

  context 'not update tracker' do
    it 'records the tweet response' do
      expect(TimelineHelper).to_not receive(:update_tracker!)
      expect {
        worker.perform(brand.id, response_hash)
      }.to change {
        TwitterResponse.count
      }.from(0).to(1)
    end
  end
end
