class AdminController < ApplicationController
  
  def users
    @users = User.order("created_at desc")
  end
  
end
