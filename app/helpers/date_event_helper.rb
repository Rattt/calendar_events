module DateEventHelper

  def get_link_to_action(date_event)
    current_event = date_event.event

    current_class = 'other'

    if current_event.user_id == current_user.id
      href = edit_event_path(current_event)
      current_class = 'my_event'
    else
      href = event_path(current_event)
    end

    link_to(current_event.name, href, class: current_class)
  end

end