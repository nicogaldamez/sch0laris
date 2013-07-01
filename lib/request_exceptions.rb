module RequestExceptions
  
  class RequestError < StandardError
    attr_reader :message, :code, :data

    def initialize(message = nil, code = 500, data = [])
      @message = message
      @code = code
      @data = data
    end
  end
  
  class BadRequestError < RequestError
    def initialize(message = nil, data = [])
      super(message, 400, data)
    end
  end
  
  class UnauthorizedError < RequestError
    def initiliaze
      @code = 401
    end
  end
  
  class ForbiddenError < RequestError
    def initiliaze
      @code = 403
    end
  end
  
end