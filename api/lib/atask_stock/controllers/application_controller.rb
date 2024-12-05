class AtaskStock::Controllers::ApplicationController < ActionController::API
  def success(data, status = :ok)
    render json: { data: data }, status: status
  end

  def error(exception)
    render json: { status: Rack::Utils::SYMBOL_TO_STATUS_CODE[exception.status], error: exception.title, exception: "#<#{exception.class}: #{exception.message}>", traces: exception.backtrace }, status: exception.status
  end
end
