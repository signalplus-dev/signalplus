require 'rails_helper'

describe ListenSignalHandler do
  let(:identity)         { create(:identity) }
  let(:brand)            { identity.brand }
  let(:listen_signal)    { create(:listen_signal, :with_response_group, brand: brand, identity: identity) }
  let(:signal_params)  {
    {
      name: 'test signal',
      active: false,
      signal_type: 'offer',
      brand: brand,
      identity: identity
    }
  }
  let(:response_params) {
    {
      'default_response': 'default test ',
      'repeat_response': 'repeat test',
      'responses': [
        { message: 'timed1 test', expiration_date: '2016-12-25' },
        { message: 'timed2 test', expiration_date: '2017-01-01' }
      ]
    }
  }

  describe '#create' do
    subject { described_class.new(nil, signal_params, response_params) }
    before(:each) { subject.create }

    it 'creates listen signal' do
      expect(ListenSignal.count).to eq(1)
    end

    it 'creates response group' do
      expect(ResponseGroup.count).to eq(1)
    end

    it 'creates default responses' do
      expect(Response.where(response_type: 'default').count).to eq(1)
    end

    it 'creates repeat response' do
      expect(Response.where(response_type: 'repeat').count).to eq(1)
    end

    it 'creates timed responses' do
      expect(Response.where(response_type: 'timed').count).to eq(2)
    end
  end


  describe '#update' do
    let!(:name)               { listen_signal.name }
    let!(:response_group)    { listen_signal.response_group }
    let!(:default_response)  { create(:response, :default, response_group: response_group) }
    let!(:repeat_response)   { create(:response, :repeat, response_group: response_group) }
    let!(:timed_response1)   { create(:response, :timed, response_group: response_group) }
    let!(:timed_response2)   { create(:response, :timed, response_group: response_group) }

    subject { described_class.new(listen_signal, signal_params, response_params) }
    before(:each) { subject.update }

    it 'does not create listen signal' do
      expect(ListenSignal.count).to eq(1)
    end

    it 'does not create response group' do
      expect(ResponseGroup.count).to eq(1)
    end

    it 'updates listen signal' do
      expect(listen_signal.name).not_to eq(name)
    end

    it 'updates default response' do
      expect(listen_signal.default_response.message).not_to eq(default_response.message)
    end

    it 'updates repeat response' do
      expect(listen_signal.repeat_response.message).not_to eq(repeat_response.message)
    end

    it 'updates timed response' do
      expect(listen_signal.timed_responses.first.message).not_to eq(timed_response1.message)
      expect(listen_signal.timed_responses.last.message).not_to eq(timed_response2.message)
    end

    context 'with deleted timed response' do
      let(:response_params) {
        {
          'default_response': 'default test ',
          'repeat_response': 'repeat test',
          'responses': [
            { message: 'timed1 test', expiration_date: '2016-12-25' }
          ]
        }
      }

      it 'deletes a timed response' do
        expect(listen_signal.timed_responses.count).to eq(1)
      end
    end
  end
end
