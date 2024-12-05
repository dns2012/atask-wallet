class Api::V1::WalletController < ApplicationController
  include AuthenticatableConcern
  include WalletConcern

  before_action :authenticate
  before_action :set_user_wallet
  before_action :set_target_wallet, only: [ :transfer ]

  before_action :validate_amount_params, only: [ :deposit, :withdraw, :transfer ]
  before_action :validate_transfer_params, only: :transfer
  before_action :validate_balance_amount, only: [ :withdraw, :transfer ]
  before_action :validate_target_wallet, only: [ :transfer ]

  api :GET, "/v1/wallet", "Show Current User Wallet Data"
  header "Authorization", "Bearer token (required)", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        id: 2,
        user_id: 2,
        balance: 100000,
        wallet_alias: "Bob Wallet",
        created_at: "2024-12-02T05:55:47.518Z",
        updated_at: "2024-12-02T09:58:11.733Z"
      }
    }
  )
  def index
    success(@user_wallet)
  end

  api :GET, "/v1/wallet/history", "Show Current User Wallet Activity History Data"
  header "Authorization", "Bearer token (required)", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: [
        {
          id: 5,
          user_wallet_id: 2,
          balance_type: "credit",
          balance_amount: 50000,
          user_transaction_id: 5,
          created_at: "2024-12-02T05:44:00.629Z",
          updated_at: "2024-12-02T05:44:00.629Z"
        }
      ]
    }
  )
  def history
    success(@user_wallet.histories)
  end

  api :POST, "/v1/wallet/deposit", "Deposit Amount of Balance to The Current User Wallet"
  header "Authorization", "Bearer token (required)", required: true
  param :amount, Integer, desc: "Amount of the deposit", required: true
  error code: 401, desc: "Unauthorized"
  error code: 400, desc: "Bad Request"
  formats [ "json" ]
  example "Request Body (JSON) :"
  example JSON.pretty_generate(
    {
      amount: 100000
    }
  )
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        id: 2,
        user_id: 2,
        balance: 100000,
        wallet_alias: "Bob Wallet",
        created_at: "2024-12-02T05:55:47.518Z",
        updated_at: "2024-12-02T09:58:11.733Z"
      }
    }
  )
  def deposit
    @user_wallet.deposit(params[:amount])
    success(@user_wallet, :created)
  end

  api :POST, "/v1/wallet/transfer", "Transfer Amount of Balance from Current User Wallet to The Another Wallet Account (Wallet ID)"
  header "Authorization", "Bearer token (required)", required: true
  param :user_wallet_id, Integer, desc: "Target wallet id to receive the balance tranfer", required: true
  param :amount, Integer, desc: "Amount of the balance transfer", required: true
  error code: 401, desc: "Unauthorized"
  error code: 400, desc: "Bad Request"
  error code: 404, desc: "Not Found"
  formats [ "json" ]
  example "Request Body (JSON) :"
  example JSON.pretty_generate(
    {
      user_wallet_id: 3,
      amount: 50000
    }
  )
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        id: 2,
        user_id: 2,
        balance: 50000,
        wallet_alias: "Bob Wallet",
        created_at: "2024-12-02T05:55:47.518Z",
        updated_at: "2024-12-02T09:58:11.733Z"
      }
    }
  )
  def transfer
    exec_transfer
    success(@user_wallet, :created)
  end

  api :POST, "/v1/wallet/withdraw", "Withdraw Amount of Balance From Current User Wallet"
  header "Authorization", "Bearer token (required)", required: true
  param :amount, Integer, desc: "Amount of the withdraw", required: true
  error code: 401, desc: "Unauthorized"
  error code: 400, desc: "Bad Request"
  formats [ "json" ]
  example "Request Body (JSON) :"
  example JSON.pretty_generate(
    {
      amount: 100000
    }
  )
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: {
        id: 2,
        user_id: 2,
        balance: 0,
        wallet_alias: "Bob Wallet",
        created_at: "2024-12-02T05:55:47.518Z",
        updated_at: "2024-12-02T09:58:11.733Z"
      }
    }
  )
  def withdraw
    @user_wallet.withdraw(params[:amount])
    success(@user_wallet, :created)
  end

  api :GET, "/v1/wallet/list", "Show Another Account Wallet List Data"
  header "Authorization", "Bearer token (required)", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      data: [
        {
          id: 1,
          user_id: 1,
          balance: 150000,
          wallet_alias: "Atask Master Wallet",
          created_at: "2024-12-02T05:55:47.515Z",
          updated_at: "2024-12-02T05:55:47.549Z"
        },
        {
          id: 3,
          user_id: 3,
          balance: 100000,
          wallet_alias: "John Wallet",
          created_at: "2024-12-02T05:55:47.521Z",
          updated_at: "2024-12-02T05:56:50.544Z"
        }
      ]
    }
  )
  def list
    success(UserWallet.where.not(user_id: @current_user.id))
  end

  private

  def validate_amount_params
    params.expect(:amount)
    raise BadRequestException.new("invalid amount, minimum transaction is #{Rails.application.config.minimum_transaction_amount}") unless params[:amount] >= Rails.application.config.minimum_transaction_amount
  end

  def validate_transfer_params
    params.expect(:user_wallet_id)
  end
end
