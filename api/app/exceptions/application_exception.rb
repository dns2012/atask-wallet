class ApplicationException < StandardError
  attr_reader :message, :title, :status

  def initialize(message, status = :not_found, title = "Unauthorized")
    @message = message
    @status = status
    @title = title
  end
end
