class DateEvent < ActiveRecord::Base

  belongs_to :event

  scope :get_date_last_point, -> {order(date_start: :desc).limit(1).pluck(:date_start).first }
  scope :get_date_start_first_event_occurs, -> { where("DATE(date_start) > ?", Date.today).order(date_start: :asc).limit(1).pluck(:date_start).first }
  scope :get_ids_future_events, -> { where("DATE(date_start) > ?", Date.today).pluck(:id) }
  scope :get_ids_date_event_old, -> { where("DATE(date_start) < ?", Date.today - 3.month).pluck(:id) }


  def self.get_collection_event_date(record)
    date_end_before_next_generation = Date.today + 3.month
    array_records = []

    last_date_point = record.event.date_events.get_date_last_point

    if  record.date_start < (date_end_before_next_generation)
      array_records << record.attributes.dup
    end

    type_event = record.event.type_event

    if type_event == 'not_repeat' && !(last_date_point.present?)
      return array_records
    end

    if  last_date_point.present? && record.date_start < last_date_point
      return nil
    end


    template_record = record.attributes.dup
    new_date_start = template_record["date_start"]
    new_date_start = get_new_date_start(new_date_start, type_event)

    if  new_date_start < (date_end_before_next_generation)
      while new_date_start < (date_end_before_next_generation)

        template_record["date_start"] = new_date_start
        template_record["id"] = nil

        array_records << template_record.dup

        new_date_start = DateEvent.get_new_date_start(new_date_start, type_event)
      end
    end

    array_records
  end

  def self.generate_dates_event(event, date_start)
    date_event = event.date_events.build(date_start: date_start)
    new_rows_hash = DateEvent.get_collection_event_date(date_event)

    #Fast
    DateEvent.single_mass_insert_sql!(new_rows_hash) if new_rows_hash.present?

  end

  def self.single_mass_insert_sql!(rows)
    inserts = []
    rows.each  do |row|
      inserts.push "(#{row["event_id"]},\'#{row["date_start"]}\')"
    end
    sql = "INSERT INTO date_events (event_id, date_start) VALUES #{inserts.join(", ")}"
    connection = ActiveRecord::Base.connection
    connection.execute(sql)
  end

  def start_time
    self.date_start
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
