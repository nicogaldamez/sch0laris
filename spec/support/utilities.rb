# encoding: UTF-8

def js_log_in(email, password)
  visit root_path
  click_link 'show_sign_in_btn'
  fill_in "sign_in_email", with: email
  fill_in "sign_in_password", with: password
  click_button "sign_in_btn"
  sleep 1
  visit root_path
  page.should have_content(user.name)
end

def manual_log_in(attributes = {})
  @_current_user = FactoryGirl.create(:user, password: 'Secret123', password_confirmation: 'Secret123')
  post sessions_path, email: @_current_user.email, password: 'Secret123'
  visit root_path
  page.should have_content @_current_user.name
end

def log_in(attributes = {})
  @_current_user = FactoryGirl.create(:user, attributes)
  
  visit root_path
  fill_in "sign_in_email", with: @_current_user.email
  fill_in "sign_in_password", with: @_current_user.password
  click_button "sign_in_btn"
  page.should have_content @_current_user.name
end

def current_user
  @_current_user
end