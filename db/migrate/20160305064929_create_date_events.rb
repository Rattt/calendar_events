class CreateDateEvents < ActiveRecord::Migration
  def self.up
    create_table :date_events do |t|
      t.integer :event_id, null: false
      t.date :date_start, null: false, index: true
    end
  end

  def self.down
    drop_table :date_events
  end
end
