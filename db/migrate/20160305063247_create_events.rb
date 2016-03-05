class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id, null: false
      t.string :name, unique: true, null: false
      t.integer :type_event, null: false
    end
  end
  def self.down
    drop_table :events
  end
end
