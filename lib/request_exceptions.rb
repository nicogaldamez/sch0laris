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
      super(message, 401, data)
    end
  end
  
  class ForbiddenError < RequestError
    def initiliaze
      super(message, 403, data)
    end
  end
  
end