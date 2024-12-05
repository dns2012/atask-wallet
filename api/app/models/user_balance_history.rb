class UserBalanceHistory < ApplicationRecord
  validates :balance_amount, presence: true, numericality: { only_integer: true }

  enum :balance_type, credit: 1, debit: 2

  belongs_to :user_wallet
  belongs_to :user_transaction
end
