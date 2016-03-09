module EventDateHelper

  def get_link_to_action(date_event)
    current_event = date_event.event

    if current_event.user_id == current_user.id
      href = edit_event_path(current_event)
      classes = 'my_event'
    else
      classes = 'other'
      href = event_path(current_event)
    end

    if date_event.event_occurs?
      classes = classes + ' event_occurs'
    end

    if date_event.date_start < Date.today
      classes = classes + ' last_date'
    end

    link_to(current_event.name, href, class: classes)
  end

end