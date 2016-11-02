require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load application ENV vars and merge with existing ENV vars.
# Loaded here so can use values in initializers.
ENV.update YAML.load_file('config/application.yml') rescue {}
WHITE_LIST_OF_KEYS_AVAILABLE_FOR_NODE = [
  'SITE_URL',
  'STRIPE_PUBLIC_KEY',
  'DOMAIN',
  'RAILS_ENV',
  'ACTION_CABLE_URL',
]

module ProjectSignal
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/workers
      #{config.root}/app/workers/kiqs
      #{config.root}/app/workers/tiqs
      #{config.root}/app/services
      #{config.root}/app/services/responders
      #{config.root}/app/services/streamers
      #{config.root}/app/services/promotional_tweet
      #{config.root}/app/services/stripe
      #{config.root}/app/models/strategies
      #{config.root}/app/errors
    )

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.after_initialize do
      if Sidekiq.server?
        Rails.logger.info("Intitializing twitter streams")
        Brand.twitter_streaming_query.find_each do |brand|
          BackgroundRake.call_rake(:twitter_stream, brand_id: brand.id)
        end
      end
    end

    # Configure Browserify to use babelify to compile ES6
    env_vars = ENV.to_hash.slice(*WHITE_LIST_OF_KEYS_AVAILABLE_FOR_NODE).map do |key, value|
      "--#{key} #{value}"
    end.join(' ')
    config.browserify_rails.commandline_options = [
      "-t [ babelify --presets [ es2015 react stage-0 ] ]",
      "-t [ envify #{env_vars} ]",
    ]

    unless Rails.env.production?
        # Work around sprockets+teaspoon mismatch:
        Rails.application.config.assets.precompile += %w(spec_helper.js)

        # Make sure Browserify is triggered when
        # asked to serve javascript spec files
        config.browserify_rails.paths << lambda { |p|
            p.start_with?(Rails.root.join("spec/javascripts").to_s)
        }
    end
  end
end
