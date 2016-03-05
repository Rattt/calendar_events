class DateEvent < ActiveRecord::Base

  belongs_to :events

  validates :event_id, presense: true, numericality: true
  validates :date_start, presense: true, date: true

end
