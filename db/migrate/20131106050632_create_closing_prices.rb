class CreateClosingPrices < ActiveRecord::Migration
  def change
    create_table :closing_prices do |t|
      t.float :price
      t.date :date
      t.integer :security_id
      t.index :security_id
    end
  end
end
