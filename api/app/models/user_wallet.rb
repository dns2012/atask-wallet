class UserWallet < ApplicationRecord
  has_many :source_user_transactions, class_name: "UserTransaction", foreign_key: "source_user_wallet_id"
  has_many :target_user_transactions, class_name: "UserTransaction", foreign_key: "target_user_wallet_id"
  has_many :user_balance_history

  def transactions
    UserTransaction.where("source_user_wallet_id = ? OR target_user_wallet_id = ?", id, id).order(created_at: :desc)
  end

  def histories
    user_balance_history.order(created_at: :asc)
  end

  def sum_balance
    self.balance = user_balance_history.sum(:balance_amount)
    save!
  end

  def is_transferable?(target_user_wallet_id)
    target_user_wallet_id != id
  end

  def is_sufficient?(amount)
    balance >= amount
  end

  def withdraw(amount)
    ActiveRecord::Base.transaction do
      user_transaction = source_transaction(amount, :withdraw)
      debit_balance(amount, user_transaction.id)
      sum_balance
    end
  end

  def deposit(amount)
    ActiveRecord::Base.transaction do
      user_transaction = target_transaction(amount, :deposit)
      credit_balance(amount, user_transaction.id)
      sum_balance
    end
  end

  def transfer(amount, target_wallet_id)
    user_transaction = source_transaction(amount, :transfer, target_wallet_id)
    debit_balance(amount, user_transaction.id)
    sum_balance
    user_transaction
  end

  def receive(amount, user_transaction_id)
    credit_balance(amount, user_transaction_id)
    sum_balance
  end

  def source_transaction(amount, transaction_type, target_wallet_id = nil)
    source_user_transactions.create!(source_user_wallet_id: id, target_user_wallet_id: target_wallet_id, transaction_type: transaction_type, transaction_amount: amount)
  end

  def target_transaction(amount, transaction_type, source_wallet_id = nil)
    target_user_transactions.create!(source_user_wallet_id: source_wallet_id, target_user_wallet_id: id, transaction_type: transaction_type, transaction_amount: amount)
  end

  def debit_balance(amount, user_transaction_id)
    user_balance_history.create!(user_wallet_id: id, balance_type: :debit, balance_amount: -amount, user_transaction_id: user_transaction_id)
  end

  def credit_balance(amount, user_transaction_id)
    user_balance_history.create!(user_wallet_id: id, balance_type: :credit, balance_amount: amount, user_transaction_id: user_transaction_id)
  end
end
