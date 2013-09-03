#encoding: UTF-8
require 'spec_helper'

describe "Question request" do
  
  subject { page }
  
  it "listar preguntas como visitante" do
    FactoryGirl.create(:question, title: 'Hola')
    FactoryGirl.create(:question, title: 'Mundo')
    FactoryGirl.create(:tag, description: 'Tag 1')
    FactoryGirl.create(:tag, description: 'Tag 2')
    visit questions_path
    page.should have_content("Hola")
    page.should have_content("Mundo")
  end
  
  describe "crear una pregunta", js: true do
    include TokenInputHelper
    include Wysihtml5Helper
    let(:user) { FactoryGirl.create(:user, password: 'Secret1234', password_confirmation: 'Secret1234') }
    
    before "login" do
      js_log_in(user.email, 'Secret1234')
      visit pre_ask_questions_path
      click_on I18n.t("posts.how_to_ask.proceed")
    end
    
    it "crear una pregunta como usuario" do
      fill_in "Título", with: "Foobar"
      fill_in_wysihtml5 "Foobar"
      fill_token_input 'question_tag_tokens', with: 'tag1'
      fill_token_input 'question_tag_tokens', with: 'tag2'
      click_on "Enviar pregunta"
      page.should have_content("#{user.name} #{I18n.t('posts.list.wrote_about')}")
      page.should have_content("Foobar")
    end
  end
  
  it "eliminar una pregunta" do
    log_in
    question = FactoryGirl.create(:question, user: current_user, title: "Oops")
    visit questions_path
    page.should have_content("Oops")
    visit question_path(question)    
    click_link I18n.t(:delete)
    page.should have_content(I18n.t("success.on_delete", thing: I18n.t("success.thing.question")))
    page.should_not have_content("Oops")
  end
end