# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  signal_type     :string
#  expiration_date :datetime
#  deleted_at      :datetime
#

class ListenSignalSerializer < ActiveModel::Serializer
  attributes :id, :name, :active, :expiration_date, :signal_type

  # Associations
  has_many :promotional_tweets
  has_many :responses
end
