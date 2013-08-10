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

class Vote < ActiveRecord::Base
  attr_accessible :user_id, :value
  
  belongs_to :voteable, polymorphic: true
end
