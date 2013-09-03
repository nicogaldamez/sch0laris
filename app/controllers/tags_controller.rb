class TagsController < ApplicationController
  
  def index
    @filter = Hash.new
    @tags = Tag.order(:description)
    respond_to do |format|
      format.html
      format.json { render json: @tags.tokens(params[:q], allow?(:tags, :create)) }
    end
  end
  
end
