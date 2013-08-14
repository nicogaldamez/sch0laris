# encoding: UTF-8
class QuestionsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :ask, :pre_ask]
  before_filter :load_filter, only: [:index, :tagged]
  
  # Listado de aportes o preguntas
  def index
    
    @tab = @filter[:filter]
    @questions = Question.filter(@type, @filter, current_user).page(params[:page]).per_page(10)
    respond_to do |f|
      f.html
      f.js 
    end
  end
  
  def pre_ask
  end
  
  def ask
    @question = Question.new
  end
  
  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['title','body','tag_tokens'],:question)
    # Se admiten de 2 a 5 tags
    tags_count = params[:question][:tag_tokens].split(',').length
    logger.debug tags_count
    if tags_count < 2  || tags_count > 5
      raise(RequestExceptions::BadRequestError.new(t("questions.ask.tags_error"))) 
    end
    
    params[:question][:user_id] = current_user.id
    @clear_results = params[:change_page].blank?
    @question = Question.new(params[:question])
    if @question.save
      redirect_to @question, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@question.errors.full_messages))
    end
    
  end
  
  def show
    @question = Question.find(params[:id])
    @filter = Hash.new
    
    # Marco como vista por el usuario
    if signed_in? && @question.user != current_user
        view = @question.views.find_or_initialize_by_question_id_and_user_id(@question.id, current_user.id)
        view.save
    end
    
    @answer = @question.answers.new
  end
  
  private
    def load_filter
      @type = params[:type] || 'questions'
      @filter = Hash.new
      @filter[:tag] = params[:tag] unless params[:tag].blank?
      @filter[:filter] = params[:filter] || 'hot' # Los tabs internos (hot, reputation, ...)
      @filter[:search] = params[:search] unless params[:search].blank?
    
      if @filter[:filter] == 'my_school' 
        raise(RequestExceptions::BadRequestError.new(t(:please_sign_in))) unless signed_in?
        raise(RequestExceptions::BadRequestError.new(t("posts.list.need_school"))) if current_user.school.blank?
      end
    end
end
