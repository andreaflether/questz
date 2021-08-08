# frozen_string_literal: true

# == Schema Information
#
# Table name: notices
#
#  id              :bigint           not null, primary key
#  details         :text             not null
#  noticeable_type :integer          not null
#  reason          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  given_by_id     :integer          not null
#  user_id         :bigint
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Notice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
