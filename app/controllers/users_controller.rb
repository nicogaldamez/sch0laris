class UsersController < ApplicationController
  
  def new    
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |f|
      f.json 
    end
  end
end
