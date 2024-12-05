class UnauthorizedException < ApplicationException
  def initialize(message, title = "Unauthorized")
    super(message, :unauthorized, title)
  end
end
