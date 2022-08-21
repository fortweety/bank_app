class CreateAccounts < ActiveRecord::Migration[6.1]
  def up
    create_table :accounts do |t|
      t.integer :user_id
      t.decimal :balance, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :accounts
  end
end
