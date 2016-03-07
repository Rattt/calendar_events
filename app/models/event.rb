class Event < ActiveRecord::Base

  belongs_to :user
  has_many :date_events, dependent: :destroy

  enum type_event: { not_repeat: 0, one_repeat: 1, week_repeat: 2, month_repeat: 3, year_repeat: 4 }

  before_validation :downcase_event!

  validates :user_id, presence: true, numericality: true
  validates :name, presence: true, uniqueness: true

  def event_coming_soon_date
    date = self.date_events.get_date_start_first_event_occurs
    if date.present?
      I18n.l(date)
    else
      single_date = self.date_events.first
      I18n.t("event.last_event", date_start: I18n.l(single_date.date_start) ) if single_date.present?
    end
  end

  private

  def downcase_event!
    self.name.downcase! if name.present?
  end
end
