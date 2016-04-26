# == Schema Information
#
# Table name: identities
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

describe Brand do
  describe '.get_token_info' do
    let(:user) { FactoryGirl.create(:user) }
    let(:identity) {FactoryGirl.create(:identity)}
    let(:brand) {FactoryGirl.create(:brand)}

    it 'associates brand' do
      binding.pry
      puts user
    end
  end
end