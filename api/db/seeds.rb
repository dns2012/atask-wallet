# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  users_data = [
    { name: "Atask Master", email: "ataskmaster@mail.com", password: "atask123" },
    { name: "Bob", email: "bob@mail.com", password: "atask123" },
    { name: "John", email: "john@mail.com", password: "atask123" }
  ]

  users = users_data.map do |user_data|
    User.find_or_create_by!(email: user_data[:email]) do |user|
      user.name = user_data[:name]
      user.password = user_data[:password]
    end
  end

  user_wallets = users.map do |user|
    UserWallet.find_or_create_by!(user_id: user.id) do |wallet|
      wallet.wallet_alias = "#{user.name} Wallet"
    end
  end

  default_balance = 200000

  user_wallets.each do |wallet|
    # Reduce balance by 50K for each wallet
    deposit_amount = default_balance - 50000

    # Create user transaction record
    user_transaction = UserTransaction.find_or_create_by!(
      target_user_wallet_id: wallet.id,
      transaction_type: :deposit,
      transaction_amount: deposit_amount
    )

    # Create user balance history record
    UserBalanceHistory.find_or_create_by!(
      user_wallet_id: wallet.id,
      balance_type: :credit,
      balance_amount: deposit_amount,
      user_transaction_id: user_transaction.id
    )

    # Update wallet balance
    wallet.sum_balance
  end
end
