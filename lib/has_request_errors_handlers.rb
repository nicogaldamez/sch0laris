# Exception to raise on permission violations
class BadRequestError < StandardError;end
class UnauthorizedError < StandardError; end
class ForbiddenError < StandardError; end

module HasRequestErrorsHandlers

  # call this in resource class
  def has_request_errors_handlers
    # Excepciones asociadas a un http status code
    logger.debug "YESS"
    # extend  ClassMethods
#     include InstanceMethods
  end
  
  # def self.included(base)
#     # base.rescue_from BadRequestError, :with => :bad_request
#   end
  

  module InstanceMethods
    
    # def bad_request
#       logger.debug "BAD REQUEST"
#     end
    
  end

  module ClassMethods
    
  end

end

ActiveRecord::Base.send :extend, HasRequestErrorsHandlers