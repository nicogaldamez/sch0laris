class UsersController < ApplicationController
  include ApplicationHelper
  
  def new    
    if signed_in?
      redirect_to root_url
    end
    @user = User.new
  end
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['name','email'],:user)
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
      raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['name','email'],:user)
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
  
  def confirm_delete
    raise PermissionViolation unless signed_in?
    
    @user = current_user
    render "users/profile/confirm_delete"
  end
  
  def destroy
    # Verifico que la clave enviada sea la del usuario
    # Si el usuario no tiene clave no verifico nada
    if !current_user.password_required? || current_user.authenticate(params[:password]) 
      current_user.destroy
      sign_out
      redirect_to root_url
    else
      flash[:error] = t('users.profile.delete_password_error')
      redirect_to profile_delete_path
    end
  end
end
