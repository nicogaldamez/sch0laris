class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => t('password_reset.email_sent')
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    @user.updating_password = true
  end
  
  def update
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['password','password_confirmation'],:user)
    @user = User.find_by_password_reset_token!(params[:id])
    @user.updating_password = true
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: t('password_reset.expired')
    elsif @user.update_attributes(params[:user])
      flash[:notice] = t('password_reset.reset_successful')
      render 'shared/success'
    else
      raise(RequestExceptions::BadRequestError.new(@user.errors.full_messages))
    end
      
  end
end
