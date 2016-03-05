class Event < ActiveRecord::Base

  belongs_to :user
  has_many :date_events

  enum type_event: { not_repeat: 0, one_repeat: 1, week_repeat: 2, month_repeat: 3, year_repeat: 4 }

  before_validation :downcase_event!

  validates :user_id, :type_event, presence: true, numericality: true
  validates :name, presence: true, uniqueness: true
  validates_inclusion_of :type_event, :in => 0..4

  private

  def downcase_event!
    self.name.downcase! if name.present?
  end
end
