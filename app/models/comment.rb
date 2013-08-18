# encoding: UTF-8
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :integer
#  commentable_type :string(255)
#

class Comment < ActiveRecord::Base
  include PublicActivity::Common
  
  attr_accessible :body, :user_id
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  
  after_commit :create_notification, on: :create
  
  private
    def create_notification
      obj = commentable
      return false if user == obj.user
      subject = "#{user.name} escribió el siguiente comentario"
      body = "#{self.body}"
      obj.user.notify(subject, body, self)
    end
end
