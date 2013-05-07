# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  email       :string(255)      not null
#  password    :string(255)      not null
#  name        :string(255)      not null
#  dateOfBirth :date             not null
#  gender      :string(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :gender, :password, :password_confirmation, :dateOfBirth
  
  has_secure_password
  
  before_save { |user| user.email = email.downcase }


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,20}$/
  
  validates :email, presence:true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :name, presence:true, length:{maximum:40}
  validates :password, presence:true, format: { with: VALID_PASSWORD_REGEX }
  validates :password_confirmation, presence:true
  validates :dateOfBirth, presence:true
 
end
