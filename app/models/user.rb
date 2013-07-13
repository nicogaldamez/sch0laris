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
#  remember_token  :string(255)
#  gender          :string(1)
#  avatar          :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :dateOfBirth, :gender, :avatar,
                  :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :updating_password
  mount_uploader :avatar, AvatarUploader
  
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  after_update :crop_avatar


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Clave entre 8 y 20 caracteres
  # mayúsculas y minúsculas, letras y números
  VALID_PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,20}$/
  
  validates :email, presence:true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :name, presence:true, length:{ maximum:40 }
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: I18n.t(:weak_password) }, :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :should_validate_password?
  validates :dateOfBirth, presence: { message: I18n.t(:wrong_or_blank_date) } 

  def should_validate_password?
    updating_password || new_record?
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def crop_avatar
      avatar.recreate_versions! if crop_x.present?
    end
end
