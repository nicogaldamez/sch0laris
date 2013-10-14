class UsersController < ApplicationController
  include ApplicationHelper
  
  def new    
    if signed_in?
      redirect_to root_url
    end
    @user = User.new
  end
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['dateOfBirth','name','email'],:user)
    params[:user][:dateOfBirth] = parse_date(params[:user][:dateOfBirth])
    @user = User.new(params[:user])
    @user.school_id = nil if params[:user][:school_id].blank?
    if @user.save
      sign_in @user
      redirect_to @user, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
  end
  
  def show
    @filter = Hash.new
    @user = User.find(params[:id])
    @feed = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:id])
    respond_to do |f|
      f.json 
      f.html
    end
  end
  
  def personal_profile
    raise PermissionViolation unless signed_in?
    
    @user = current_user
    render "users/profile/personal"
  end
  
  def password_profile
    raise PermissionViolation unless signed_in?
    
    @user = current_user
    @user.updating_password = true
    
    render "users/profile/password"
  end
  
  def avatar_profile
    raise PermissionViolation unless signed_in?
    
    @user = current_user
    
    render "users/profile/avatar"
  end
  
  def update
    @user = current_user
    if params[:user][:password] != nil
      raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['password','password_confirmation'],:user)
    elsif params[:user][:name] != nil
      @user.school_id = nil if params[:user][:school_id].blank?
      raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['name','email','dateOfBirth'],:user)
    end
    
    if @user.update_attributes(params[:user])
      sign_in @user
      @message = t(:changes_saved)
      render 'shared/success'
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
  end
  
  def upload_avatar
    @user = current_user
    if @user.update_attributes(params[:user])
      sign_in @user
      render :crop
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
  end
  
  def crop_avatar
    @user = current_user
    @user.crop_x = params[:user][:crop_x]
    @user.crop_y = params[:user][:crop_y]
    @user.crop_w = params[:user][:crop_w]
    @user.crop_h = params[:user][:crop_h]
    if @user.save
      sign_in @user
      redirect_to root_url
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
  end
  
  
end
