class AdminController < ApplicationController
  
  def users
    @users = User.order("created_at desc").page(params[:page]).per_page(20)
  end
  
end
