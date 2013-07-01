module RequestExceptions
  
  class RequestError < StandardError
    attr_reader :message, :code

    def initialize(message = nil, code = 502)
      @message = 'aasasd'
      @code = code
    end
  end
  
  class BadRequestError < RequestError
    def initialize(message = nil, code = 400)
      super('aasdmapsmdpo')
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