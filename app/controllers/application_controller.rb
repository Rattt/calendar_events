class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include DateEventHelper

  before_action :set_locale


  def self.default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  private

  def extract_locale_from_accept_language_header
    req_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first rescue nil
    return req_locale if I18n.available_locales.include? req_locale
    nil
  end

  def set_locale
    session[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = session[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end

end
