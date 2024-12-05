class Api::V1::TransactionController < ApplicationController
  include AuthenticatableConcern
  include WalletConcern

  before_action :authenticate
  before_action :set_user_wallet

  api :GET, "/v1/transaction", "Show Current User Transaction List Data"
  header "Authorization", "Bearer token (required)", required: true
  error code: 401, desc: "Unauthorized"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      "data": [
        {
          "id": 2,
          "transaction_type": "deposit",
          "created_at": "2024-12-06T01:31:28.734Z",
          "balance_type": "credit",
          "balance_amount": 100000,
          "from_wallet_alias": nil,
          "to_wallet_alias": "Bob Wallet"
        },
        {
          "id": 4,
          "transaction_type": "transfer",
          "created_at": "2024-12-06T01:48:56.505Z",
          "balance_type": "debit",
          "balance_amount": -50000,
          "from_wallet_alias": "Bob Wallet",
          "to_wallet_alias": "John Wallet"
        }
      ]
    }
  )
  def index
    transactions = UserTransaction.with_user_balance_histories
                       .with_optional_source_wallet
                       .with_optional_target_wallet
                       .with_related_wallet_transactions(@user_wallet.id)
                       .default_selection
                       .order(created_at: :asc)
    success(transactions)
  end
end
