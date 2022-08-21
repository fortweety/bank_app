class CreateTransactions < ActiveRecord::Migration[6.1]
  def up
    create_table :transactions, id: :uuid do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.integer :from_id
      t.integer :to_id, null: false
      t.string :variety, null: false

      t.timestamps
    end
  end

  def down
    drop_table :transactions
  end
end
