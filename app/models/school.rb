class School < ActiveRecord::Base
  attr_accessible :acronym, :name
  
  validates :name, presence: true
end
