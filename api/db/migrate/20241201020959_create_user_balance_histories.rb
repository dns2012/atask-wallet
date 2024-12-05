class CreateUserBalanceHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :user_balance_histories do |t|
      t.references :user_wallet, null: false, foreign_key: true
      t.integer :balance_type, default: 0
      t.integer :balance_amount, default: 0
      t.references :user_transaction, null: false, foreign_key: true
      t.timestamps
    end
  end
end
