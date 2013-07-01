# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  dateOfBirth     :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :dateOfBirth
  
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Clave entre 8 y 20 caracteres
  # mayúsculas y minúsculas, letras y números
  VALID_PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,20}$/
  
  validates :email, presence:true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :name, presence:true, length:{ maximum:40 }
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: I18n.t(:weak_password) }
  validates :password_confirmation, presence: { message: '' }
  validates :dateOfBirth, presence:true

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
