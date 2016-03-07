class DateEvent < ActiveRecord::Base

  belongs_to :event

  scope :get_date_start_first_event_occurs, -> { where("DATE(date_start) > ?", Date.today).order(date_start: :asc).limit(1).pluck(:date_start).first }
  scope :get_ids_future_events, -> { where("DATE(date_start) > ?", Date.today).pluck(:id) }

  validates :event_id, presence: true, numericality: true
  validates :date_start, presence: true, date: true


  def self.get_collection_event_date(record)
    date_end_before_next_generation = Date.today.year+2
    array_records = []

    if  record.date_start.year < (date_end_before_next_generation)
      array_records << record.attributes.dup
    end

    type_event = record.event.type_event

    if type_event == 'not_repeat'
      return array_records
    end


    template_record = record.attributes.dup
    new_date_start = template_record["date_start"]
    new_date_start = get_new_date_start(new_date_start, type_event)

    if  new_date_start.year < (date_end_before_next_generation)
      while new_date_start.year < (date_end_before_next_generation)

        template_record["date_start"] = new_date_start
        template_record["id"] = nil

        array_records << template_record.dup

        new_date_start = DateEvent.get_new_date_start(new_date_start, type_event)
      end
    end

    array_records
  end

  def start_time
    self.date_start
  end

  def date_range
    beginning =  Date.today.year + 1
    ending    = self.date_start + 1.day
  end

  private

  def self.get_new_date_start(new_date_start ,type_event)
    case type_event
      when 'one_repeat'
        new_date_start + 1.days
      when 'week_repeat'
        new_date_start + 1.weeks
      when 'month_repeat'
        new_date_start + 1.months
      when 'year_repeat'
        new_date_start + 1.years
    end
  end

end
