class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.integer :security_id
      t.integer :data_type_id
      t.hstore :data
    end
  end
end
