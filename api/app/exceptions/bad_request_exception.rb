class BadRequestException < ApplicationException
  def initialize(message, title = "Bad Request")
    super(message, :bad_request, title)
  end
end
