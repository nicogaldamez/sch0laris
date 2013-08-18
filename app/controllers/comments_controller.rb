class CommentsController < ApplicationController
  before_filter :load_commentable
  before_filter :signed_in_user
  before_filter :belongs_to_user, only: [:destroy]
  
  def new
    @comment = @commentable.comments.new
    render 'new', layout: false
  end

  def create
    raise(RequestExceptions::BadRequestError.new(t(:missing_params))) unless check_params?(['body'], :comment)
    @comment = @commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id
    if !@comment.save
      raise(RequestExceptions::BadRequestError.new(@comment.errors.full_messages))
    else
      @comment.create_activity :create, owner: current_user
      render 'create', layout: false
    end
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def destroy
    if !@comment.destroy
      raise(RequestExceptions::BadRequestError.new(@comment.errors.full_messages))
    else
      render 'shared/success'
    end
  end

private
  def belongs_to_user
    @comment = Comment.find(params[:id])
    raise(RequestExceptions::ForbiddenError.new(t(:no_permission))) unless @comment.user == current_user    
  end

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end
