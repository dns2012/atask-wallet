class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.text :description
      t.string :code
      t.integer :available_lot
      t.integer :current_price_per_lot
      t.timestamps
    end
  end
end
