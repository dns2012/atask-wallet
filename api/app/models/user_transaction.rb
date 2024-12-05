class UserTransaction < ApplicationRecord
  validates :transaction_amount, presence: true, numericality: { only_integer: true }

  enum :transaction_type,  deposit: 1, transfer: 2, withdraw: 3

  scope :with_related_wallet_transactions, -> (wallet_id) { 
    where('(user_transactions.source_user_wallet_id = ? OR user_transactions.target_user_wallet_id = ?) AND user_balance_histories.user_wallet_id = ?', wallet_id, wallet_id, wallet_id) 
  }

  scope :with_user_balance_histories, -> { 
    joins('INNER JOIN user_balance_histories ON user_balance_histories.user_transaction_id = user_transactions.id') 
  }

  scope :with_optional_source_wallet, -> { 
    joins('LEFT JOIN user_wallets AS source_wallet ON user_transactions.source_user_wallet_id = source_wallet.id')
  }

  scope :with_optional_target_wallet, -> { 
    joins('LEFT JOIN user_wallets AS target_wallet ON user_transactions.target_user_wallet_id = target_wallet.id')
  }

  scope :default_selection, -> { 
    select("user_transactions.id, 
        user_transactions.transaction_type, 
        user_transactions.created_at,
        CASE
            WHEN user_balance_histories.balance_type = 1 THEN 'credit'
            WHEN user_balance_histories.balance_type = 2 THEN 'debit'
        END AS balance_type,
        user_balance_histories.balance_amount, 
        source_wallet.wallet_alias AS from_wallet_alias,
        target_wallet.wallet_alias AS to_wallet_alias"
      ) 
    }
end
