module ApplicationHelper

  def current_locale
    case I18n.locale
      when :en
        "English"
      when :ru
        "Русский"
    end
  end

end
