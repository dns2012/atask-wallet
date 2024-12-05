class CreateUserTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_transactions do |t|
      t.references :source_user_wallet, foreign_key: { to_table: :user_wallets }
      t.references :target_user_wallet, foreign_key: { to_table: :user_wallets }
      t.integer :transaction_type, default: 0
      t.integer :transaction_amount, default: 0
      t.timestamps
    end
  end
end
