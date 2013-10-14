# encoding: UTF-8
class QuestionsController < ApplicationController
  impressionist actions: [:show]
  
  before_filter :signed_in_user, only: [:create, :ask, :pre_ask]
  before_filter :load_filter, only: [:index, :tagged]
  
  # Listado de aportes o preguntas
  def index
    @tab = @filter[:filter]
    @page = params[:page] || 1
    @questions = Question.filter(@type, @filter, current_user).page(params[:page]).per_page(10)
    respond_to do |f|
      f.html
      f.js 
    end
  end
  
  def pre_ask
    # Si la última pregunta que hizo fue hace menos de 30 días 
    # no muestro el pre_ask
    last_question = current_user.last_question
    unless last_question.nil?
      if 30.days.ago < last_question.created_at
        redirect_to ask_url
      end
    end
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
      @question.create_activity :create, owner: current_user
      redirect_to @question, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@question.errors.full_messages))
    end
    
  end
  
  def show
    @question = Question.find(params[:id])
    @filter = Hash.new
    
    @answer = @question.answers.new
    
    respond_to do |f|
      f.json
      f.html
    end
  end
  
  def destroy
    @question = current_resource
    if @question.destroy
      redirect_to questions_url, notice: t("success.on_delete", thing: t("success.thing.question"))
    else
      redirect_to questions_url, error: t("errors.on_delete", thing: t("errors.thing.question"))
    end
  end
  
  def edit
    @question = current_resource
    
    render 'ask'
  end
  
  def update
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['title','body','tag_tokens'],:question)
    
    # Se admiten de 2 a 5 tags
    tags_count = params[:question][:tag_tokens].split(',').length
    logger.debug tags_count
    if tags_count < 2  || tags_count > 5
      raise(RequestExceptions::BadRequestError.new(t("questions.ask.tags_error"))) 
    end
  
    @clear_results = params[:change_page].blank?
    @question = Question.find(params[:question][:id])
    if @question.update_attributes(params[:question])
      @question.create_activity :update, owner: current_user
      redirect_to @question, format: :json
    else
      raise(RequestExceptions::BadRequestError.new(@question.errors.full_messages))
    end
  end
  
  def history
    @versions = @question.versions
    render 'shared/history'
  end
  
  private
    def load_filter
      @type = params[:type] || 'questions'
      @filter = Hash.new
      @filter[:tag] = params[:tag] unless params[:tag].blank?
      @filter[:filter] = params[:filter] || 'most_recent' # Los tabs internos (hot, reputation, ...)
      @filter[:search] = params[:search] unless params[:search].blank?
      @clear_results = params[:clear] unless params[:clear].blank?
    
      if @filter[:filter] == 'my_school' 
        raise(RequestExceptions::BadRequestError.new(t(:please_sign_in))) unless signed_in?
        raise(RequestExceptions::BadRequestError.new(t("posts.list.need_school"))) if current_user.school.blank?
      end
    end
    
    def current_resource
      @question = @current_resource ||= Question.find(params[:id]) if params[:id]
    end
end
