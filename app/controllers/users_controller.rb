class UsersController < ApplicationController
  
  def new    
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save
    render 'show', status: 400
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |f|
      f.json 
      f.html
    end
  end
end
