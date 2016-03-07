class VirtualEvent
  include Soulless.model

  attribute :id, Integer
  attribute :user_id, Integer
  attribute :name, String
  attribute :type_event, String
  attribute :date_start, Date

  before_validation :downcase_event!

  validates :user_id, presence: true, numericality: true
  validates_with  EventNameUniqueness
  validates :date_start, presence: true,  date: { after: Proc.new { Date.today } }

  def update(event)
    if valid?
      event.update(name: name, type_event: type_event)
      DateEvent.delete_all(["id in (?)", event.date_events.get_ids_future_events])
      DateEvent.generate_dates_event(event, date_start)
      true
    else
      false
    end
  end

  def save
    if valid?
      event = Event.create!(user_id: user_id, name: name, type_event: type_event)
      DateEvent.generate_dates_event(event, date_start)
      true
    else
      false
    end
  end

  private

  def downcase_event!
    self.name.downcase! if name.present?
  end

end