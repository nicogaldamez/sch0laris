# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  name                   :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  gender                 :string(1)
#  avatar                 :string(255)
#  school_id              :integer
#  other_school           :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  reputation             :integer          default(1)
#  real_reputation        :integer          default(1)
#

class User < ActiveRecord::Base
  acts_as_messageable
  
  attr_accessible :email, :name, :password, :password_confirmation, :gender, :avatar,
                  :crop_x, :crop_y, :crop_w, :crop_h, :school_id, :other_school, :updating_password
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :updating_password
  mount_uploader :avatar, AvatarUploader
  
  has_secure_password
  
  belongs_to :school
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :questions, dependent: :destroy
  
  before_save { |user| user.email = email.downcase unless email == nil }
  # before_create { create_remember_token(:remember_token) }
  before_validation :save_other_school
  after_update :crop_avatar


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Clave entre 8 y 20 caracteres
  # mayúsculas y minúsculas, letras y números
  VALID_PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,20}$/
  
  validates :email, presence:true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, :if => :is_new_or_is_not_social_network?
  validates :name, presence:true, length:{ maximum:40 }
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: I18n.t(:weak_password) }, :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :should_validate_password?

  def send_password_reset
    create_remember_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def mailboxer_email(object)
    self.email
  end
  
  def self.from_omniauth(auth)
      where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end
  
  def should_validate_password?
    updating_password || new_record? && is_not_social_callback?
  end
  
  def is_not_social_callback?
    provider.blank?
  end

  def self.create_from_omniauth(auth)
    if (auth["provider"].downcase.eql?("facebook"))
      user_provider  = "facebook"
      # catch any excpetions thrown by code just to make sure we can continue even if parts of the omnia_has are missing
      begin
        name = auth['info']['name']
        email = auth['info']['email']
      rescue => ex
        logger.error("Error while parsing facebook auth hash: #{ex.class}: #{ex.message}")
      end
    elsif auth["provider"].downcase.eql?("google_oauth2")
      user_provider  = "google"
      name  = auth['info']['name']
      email = auth['info']['email']
    elsif auth['provider'].downcase.eql?("twitter")
      user_provider  = "twitter"
      name  = auth["info"]["name"]
      email = nil
    end
    
    # Existe el usuario con el email 
    if email.blank?
      user = User.find_by_provider_and_uid(user_provider, auth["uid"])
    else
      user = User.find_by_email(email) 
    end
    if user.blank?
      user = create! do |user|
        user.provider = user_provider
        user.uid = auth["uid"]
        user.email = email
        user.name = name
        user.password_digest = SecureRandom.urlsafe_base64
      end
    else
      user.provider = user_provider
      user.uid = auth["uid"]
      user.save
    end
    
    return user

  end
  
  def password_required?
    provider.blank?
  end
  
  def is_new_or_is_not_social_network?
    new_record? && is_not_social_callback?
  end

  def last_question
    self.questions.last
  end
  
  private
    def save_other_school
      self.other_school = nil if other_school.blank?
      self.school_id = nil if school_id.blank?
    end
  
    def create_remember_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
    
    def crop_avatar
      logger.debug "VA A CORTARLA!!!" if crop_x.present?
      avatar.recreate_versions! if crop_x.present?
    end
end
