class Api::V1::AuthController < ApplicationController
  include AuthenticatableConcern

  before_action :validate_login_params, only: [ :login ]
  before_action :authenticate, only: [ :me ]

  api :POST, "/v1/auth/login", "Authenticate User"
  param :email, String, desc: "Email address of the user", required: true
  param :password, String, desc: "Password for the user", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Request Body (JSON) :"
  example JSON.pretty_generate(
    {
      email: "john.doe@example.com",
      password: "securepassword123"
    }
  )
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        access_token: "2|9fc30e28faf08a24e159cc4e2c51ddbe0defb02a1a1c451ec3c822ca0befdaf4"
      }
    }
  )
  def login
    @user = User.find_by(email: params[:email])
    raise UnauthorizedException.new("user not registerd!") unless @user.present?
    return success({ access_token: @user.access_token }) if @user.authenticate(params[:password])
    raise UnauthorizedException.new("authentication failed, mismatch email and password combination!")
  end

  api :GET, "/v1/auth/me", "Show Authenticated User Data"
  header "Authorization", "Bearer token (required)", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        id: 2,
        name: "Bob",
        email: "bob@mail.com",
        created_at: "2024-12-02T04:10:07.210Z"
      }
    }
  )
  def me
    success(@current_user.to_json)
  end

  private

  def validate_login_params
    params.expect(:email, :password)
  end
end
