class CreateEventDates < ActiveRecord::Migration
  def self.up
    create_table :event_dates do |t|
      t.integer :event_id, null: false
      t.date :date_start, null: false, index: true
    end
  end

  def self.down
    drop_table :event_dates
  end
end
