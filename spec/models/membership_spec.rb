# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  room_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  coins      :integer          default(0)
#
# Indexes
#
#  index_memberships_on_room_id  (room_id)
#  index_memberships_on_user_id  (user_id)
#

require 'rails_helper'

describe Membership do
  # Structure
  it { is_expected.to respond_to :coins }

  # Associations
  it { is_expected.to belong_to(:room) }
  it { is_expected.to belong_to(:user) }

  # Validations
  it { is_expected.to validate_presence_of(:room) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_numericality_of(:coins).is_greater_than_or_equal_to(0) }
end
