#encoding: UTF-8

require "spec_helper"

RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

RSpec::Matchers.define :allow_param do |*args|
  match do |permission|
    permission.allow_param?(*args).should be_true
  end
end

describe Permission do
  describe "como visitante" do
    subject { Permission.new(nil) }
    
    it "preguntas" do
      should allow(:questions, :index)
      should allow(:questions, :show)
      should allow(:questions, :history)
      should_not allow(:questions, :ask)
      should_not allow(:questions, :create)
      should_not allow(:questions, :destroy)
      should_not allow(:questions, :pre_ask)
    end
    
    it "respuestas" do
      should allow(:answers, :history)
      should_not allow(:answers, :create)
      should_not allow(:answers, :destroy)
      should_not allow(:answers, :best_answer)
    end
    
    it "votos" do
      should_not allow(:votes, :up)
      should_not allow(:votes, :down)
    end
    
    it "comentarios" do
      should allow(:comments, :show)
      should_not allow(:comments, :new)
      should_not allow(:comments, :create)
      should_not allow(:comments, :destroy)
    end

    it "sesión" do
      should allow(:sessions, :new)
      should allow(:sessions, :create)
      should allow(:sessions, :destroy)
    end

    it "usuarios" do
      should allow(:users, :new)
      should allow(:users, :create)
    end
    
    it "notificaciones" do
      should_not allow(:notifications, :index)
      should_not allow(:notifications, :check_new)
      should_not allow(:notifications, :mark_all_as_read)
    end
  end
  
  describe "como miembro" do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_question) { FactoryGirl.build(:question, user: user) }
    let(:other_question) { FactoryGirl.build(:question) }
    let(:user_answer) { FactoryGirl.build(:answer, user: user) }
    let(:other_answer) { FactoryGirl.build(:answer) }
    let(:user_question_answer) { FactoryGirl.build(:answer, question: user_question) }
    subject { Permission.new(user) }
    
    it "preguntas" do
      should allow(:questions, :index)
      should allow(:questions, :show)
      should allow(:questions, :pre_ask)
      should allow(:questions, :ask)
      should allow(:questions, :create)
      should allow(:questions, :destroy, user_question)
      should allow(:questions, :edit, user_question)
      should allow(:questions, :update, user_question)
      should_not allow(:questions, :destroy, other_question)
      should_not allow(:questions, :edit, other_question)
      should_not allow(:questions, :update, other_question)
    end
    
    it "respuestas" do
      should allow(:answers, :create)
      should allow(:answers, :destroy, user_answer)
      should_not allow(:answers, :destroy, other_answer)
      should allow(:answers, :edit, user_answer)
      should allow(:answers, :update, user_answer)
      should_not allow(:answers, :edit, other_answer)
      should_not allow(:answers, :update, other_answer)
      
      # Mejor respuesta
      should allow(:answers, :best_answer, user_question_answer)
      should_not allow(:answers, :destroy, other_answer)
    end
    
    describe "votos a favor" do
      describe "con poca reputacion" do
        it "no debería poder votar" do
          should_not allow(:votes, :up, other_question)
        end
      end
      
      
      describe "con la reputacion necesaria" do
        before do 
          user.reputation = Reputation::REPUTATION_VOTE_UP
          user.save
        end
        it "debería poder votar" do
          should allow(:votes, :up, other_question)
        end
      end
    end
    
    describe "votos en contra" do
      describe "con poca reputacion" do
        it "no debería poder votar" do
          should_not allow(:votes, :down, other_question)
        end
      end
      
      describe "con la reputacion necesaria" do
        before do 
          user.reputation = Reputation::REPUTATION_VOTE_DOWN
          user.save
        end
        it "debería poder votar" do
          should allow(:votes, :down, other_question)
        end
      end
    end
    
    
    it "comentarios" do
      should allow(:comments, :new)
      should allow(:comments, :create)
      should allow(:comments, :show)
      should allow(:comments, :destroy)
    end
    
    it "notificaciones" do
      should allow(:notifications, :index)
      should allow(:notifications, :check_new)
    end
    
    it "sesión" do
      should allow(:sessions, :destroy)
      should allow(:password_resets, :new)
      should allow(:password_resets, :create)
      should allow(:password_resets, :edit)
      should allow(:password_resets, :update)      
    end
  
    it "usuarios" do
      should allow(:users, :show)
    end
    
    it "tags" do
      should allow(:tags, :index)
    end
    
    it "profile" do
      should allow(:users, :confirm_delete)
    end
  end
  
  describe "como moderador" do
    let(:user) { FactoryGirl.create(:user, reputation: 50000) }
    let(:question) { FactoryGirl.create(:question) }
    let(:answer) { FactoryGirl.create(:answer) }
    subject { Permission.new(user) }
    
    it "puede editar contenidos" do
      should allow(:questions, :edit)
      should allow(:questions, :update)
      should allow(:answers, :edit)
      should allow(:answers, :update)
    end
    
    it "respuestas" do
      should allow(:questions, :edit)
      should allow(:questions, :update)
    end
    
  end
      
end