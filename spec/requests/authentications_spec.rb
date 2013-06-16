require 'spec_helper'

describe "Authentications" do

  subject { page }
  
  describe "signin", js: true do 
    
  	before do 
      visit root_path
      click_link I18n.t(:sign_in)
    end
  	
  	describe "sin datos" do
  		before do
        click_button "sign_in_btn" 
      end
  		
	  	it { should have_selector('p.text-error', text: I18n.t(:sign_in_error)) }
	  end
	  
  	describe "con datos erroneos" do
  		before do
        fill_in "sign_in_email", with: "user@example.com"
        fill_in "sign_in_password", with: "UnaPassword123"
        click_button "sign_in_btn" 
      end
  		
	  	it { should have_selector('p.text-error', text: I18n.t(:sign_in_error)) }
	  end
    
	  # describe "with valid information" do
#       let(:user) { FactoryGirl.create(:user) }
#       before { sign_in user }
#       
#       it { should have_selector('title', text: user.name) }
#       it { should have_link('Users', href: users_path) }
#       it { should have_link('Profile', href: user_path(user)) }
#       it { should have_link('Settings', href: edit_user_path(user)) }
#       it { should have_link('Sign out', href: signout_path) }
#       it { should_not have_link('Sign in', href: signin_path) }
#       
#       describe "followed by signout" do
#         before { click_link "Sign out" }
#         it { should have_link("Sign in") }
#       end
#     end
  end
  
end
