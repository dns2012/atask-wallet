module AuthenticatableConcern
  extend ActiveSupport::Concern

  def authenticate
    begin
      raise UnauthorizedException.new("invalid access token!") unless request.headers["Authorization"].present?
      @token = request.headers["Authorization"]&.split(" ")&.last
      @user_token = @token.split("|")
      @user = User.find(@user_token.first)
      raise UnauthorizedException.new("invalid access token!") unless @user.hash_match?(@user.token_digest, @user_token.last)
      @current_user = @user
    rescue
      raise UnauthorizedException.new("invalid access token!")
    end
  end
end
