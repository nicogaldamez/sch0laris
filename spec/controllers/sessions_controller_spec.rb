require 'spec_helper'

describe SessionsController do 
	let(:user) { FactoryGirl.create(:user) }
	
	describe "sign in with Ajax" do 
		
		it "should respond with success" do 
			xhr :post, :create, { email: user.email, password: user.password } 
			response.should be_redirect
		end
	end
	
end