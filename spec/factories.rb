# encoding: UTF-8
FactoryGirl.define do

	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password	"Foobar123"
		password_confirmation	"Foobar123"
    dateOfBirth "01/01/1999"
    reputation 1
	end
  
  factory :question do
    title 'Título de la pregunta'
    body 'Cuerpo de la pregunta'
    post_type 'Q'
    association :user, :factory => :user
  end
  
  factory :answer do
    body 'Cuerpo de la respuesta'
    association :user, :factory => :user
    association :question, :factory => :question
  end
  
  factory :tag do
    sequence(:description) { |n| "Rag #{n}" }
  end
end