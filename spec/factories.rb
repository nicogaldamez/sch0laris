FactoryGirl.define do

	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password	"Foobar123"
		password_confirmation	"Foobar123"
    dateOfBirth "01/01/1999"

	end

end