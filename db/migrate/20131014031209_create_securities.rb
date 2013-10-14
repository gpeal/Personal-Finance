class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string :ticker
      t.string :name
      t.string :description
    end
  end
end
