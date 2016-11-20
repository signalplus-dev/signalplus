require 'rails_helper'

describe CheckBrandResponseCountWorker do
  let(:worker)          { described_class.new }
  let(:identity)        { create(:identity) }
  let(:brand)           { identity.brand }
  let(:subscription)    { double(:subscription) }

  before do
    allow(Brand).to receive(:find).with(brand.id).and_return(brand)
    allow(brand).to receive(:subscription).and_return(subscription)
  end

  context 'with less than the trial amount of messages' do
    it 'does not end the trial' do
      allow(brand).to receive(:monthly_response_count).and_return(49)
      expect(subscription).to_not receive(:end_trial!)
      worker.perform(brand.id)
    end
  end

  context 'with exactly the amount of trial messages' do
    it 'ends the trial' do
      allow(brand).to receive(:monthly_response_count).and_return(50)
      expect(subscription).to receive(:end_trial!)
      worker.perform(brand.id)
    end
  end

  context 'with more than the trial amount of messages' do
    it 'ends the trial' do
      allow(brand).to receive(:monthly_response_count).and_return(51)
      expect(subscription).to receive(:end_trial!)
      worker.perform(brand.id)
    end
  end
end
