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
  		
	  	it { should have_selector('p.text-error', text: I18n.t(:missing_params)) }
	  end
	  
  	describe "con datos erroneos" do
  		before do
        fill_in "sign_in_email", with: "user@example.com"
        fill_in "sign_in_password", with: "UnaPassword123"
        click_button "sign_in_btn" 
      end
  		
	  	it { should have_selector('p.text-error', text: I18n.t(:sign_in_error)) }
	  end
    
	  describe "con datos correctos" do
      let(:user) { FactoryGirl.create(:user) }
  		before do
        fill_in "sign_in_email", with: user.email
        fill_in "sign_in_password", with: user.password
        click_button "sign_in_btn" 
      end
      
      it "deberia loguear al usuario" do
        page.should have_content(user.name)
        page.should have_link(I18n.t(:profile))
        page.should have_link(I18n.t(:sign_in))
        page.should_not have_link(I18n.t(:sign_in))
      end
      
      # describe "followed by signout" do
#         before { click_link "Sign out" }
#         it { should have_link(I18n.t(:sign_out)) }
#       end
    end
  end
  
end
