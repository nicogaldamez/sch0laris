# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  voteable_id   :integer
#  voteable_type :string(255)
#

require 'spec_helper'

describe Vote do
  pending "add some examples to (or delete) #{__FILE__}"
end
