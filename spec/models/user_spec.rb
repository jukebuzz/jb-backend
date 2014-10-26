# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  email          :string(255)
#  uid            :string(255)
#  avatar_url     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  nickname       :string(255)
#  active_room_id :integer
#
# Indexes
#
#  index_users_on_active_room_id  (active_room_id)
#

require 'rails_helper'

describe User do
  # Structure
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :uid }
  it { is_expected.to respond_to :avatar_url }
  it { is_expected.to respond_to :created_at }
  it { is_expected.to respond_to :updated_at }
  it { is_expected.to respond_to :nickname }

  # Associations
  it { is_expected.to have_many(:memberships).dependent(:destroy) }
  it { is_expected.to have_many(:rooms).through(:memberships) }
  it { is_expected.to have_many(:acquired_rooms).with_foreign_key(:owner_id).class_name('Room') }
  it { is_expected.to belong_to(:active_room).class_name('Room') }

  # Validations
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_uniqueness_of(:uid) }

  it '#active_balance'
  it '.find_or_create_with_omniauth'
end
