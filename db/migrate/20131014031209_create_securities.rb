class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string :ticker, null: false, unique: true
      t.string :name, null: false
      t.string :description
    end
  end
end
