class EventNameUniqueness < ActiveModel::Validator
  def validate(record)
    @events = Event.where(name: record.name).where.not(id: record.id)
    if @events.present?
      record.errors[:name] << I18n.t('error.uniqueness')
    end
  end
end