class VirtualEvent
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :id, Integer
  attribute :user_id, Integer
  attribute :name, String
  attribute :type_event, String
  attribute :date_start, Date

  def update(event)
    if valid?
      event.update(name: name, type_event: type_event)
      DateEvent.delete_all(["id in (?)", event.date_events.get_ids_future_events])
      generate_dates_event(event)
      true
    else
      false
    end
  end

  def save
    if valid?
      event = Event.create!(user_id: user_id, name: name, type_event: type_event)
      generate_dates_event(event)
      true
    else
      false
    end
  end

  private

 def generate_dates_event(event)
   date_event = event.date_events.build(date_start: date_start)
   DateEvent.create(DateEvent.get_collection_event_date(date_event))
 end

end