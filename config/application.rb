require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CalendarEvents
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    I18n.config.enforce_available_locales = true
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.autoload_paths += %W("#{config.root}/app/validators/")

    config.generators do |g|
      g.helper false
      g.javascripts false
      g.template_engine :slim
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
