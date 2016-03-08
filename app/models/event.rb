class Event < ActiveRecord::Base

  belongs_to :user
  has_many :event_dates, dependent: :destroy

  enum type_event: { not_repeat: 0, one_repeat: 1, week_repeat: 2, month_repeat: 3, year_repeat: 4 }


  def event_coming_soon_date
    date = self.event_dates.get_date_start_first_event_occurs
    if date.present?
      I18n.l(date)
    else
      single_date = self.event_dates.first
      I18n.t("event.last_event", date_start: I18n.l(single_date.date_start) ) if single_date.present?
    end
  end

end
