class NotFoundException < ApplicationException
  def initialize(message, title = "Not Found")
    super(message, :not_found, title)
  end
end
