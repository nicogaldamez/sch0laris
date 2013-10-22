require "request_exceptions"
class StaticPagesController < ApplicationController
  # has_request_errors_handlers
  
  def home     
  end
    
  def faq
  end
  
  def contact    
  end
  
  def terms
    render 'static_pages/terms/terms_es'
  end
end
