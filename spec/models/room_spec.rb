# == Schema Information
#
# Table name: rooms
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  join_token     :string(255)
#  owner_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#  playlist_items :integer          default([]), is an Array
#  github_token   :string(255)
#
# Indexes
#
#  index_rooms_on_owner_id  (owner_id)
#

require 'rails_helper'

describe Room do
  # Structure
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :join_token }
  it { is_expected.to respond_to :github_token }
  it { is_expected.to respond_to :playlist_items }

  # Associations
  it { is_expected.to belong_to(:owner).class_name('User') }
  it { is_expected.to have_many(:memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:memberships) }

  # Validations
  it { is_expected.to validate_presence_of(:owner) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to allow_value('foo', 'foo_bar', 'foo-bar', 'foo99', '999').for(:name) }
  it { is_expected.not_to allow_value('Foo', 'foO', 'foo+bar', 'foo@').for(:name) }

  # Custom instance methods
  describe '#set_auth_token' do
    subject(:room) { build(:room) }

    it 'changes tokens after creating new item' do
      expect { room.save }.to change { room.join_token }.and change { room.join_token }
    end
  end

  describe '#generate_token' do
    subject(:room) { build(:room) }

    it 'set token new item and doesn\'t change existing token' do
      expect { room.generate_token(:join_token) }.to change { room.join_token }
      expect { room.generate_token(:join_token) }.not_to change { room.join_token }
    end
  end

  describe '#active_members' do
    subject(:room) { create(:room_with_members) }
    it { is_expected.to respond_to :active_members }
    it { is_expected.to have_at_least(1).active_members }
  end
end
