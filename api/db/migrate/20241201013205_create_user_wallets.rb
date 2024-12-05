class CreateUserWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :user_wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :balance, default: 0
      t.string :wallet_alias
      t.timestamps
    end
  end
end
