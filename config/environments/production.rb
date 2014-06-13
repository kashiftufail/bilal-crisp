Crisp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  if defined? GoCardless
    GoCardless.account_details = { 
      :app_id     => 'WE7NKP2XGFV4ATJ117QVM98FFPWXBJAFQXC76170M3955P0YRJ4R579MZ7ECR9CJ',
      :app_secret => '59WJ0JZABNV84VS7NYSNNRSBREPPX4S870G31J0D1AFRN6XAXNZHS7T0XEG0D2WZ',
      :token      => 'GNQ7FXSE7Z5G2H8P46AQTV0S90A9491K8W3HP6DRP1YJYQGV4VP47J5WV0Z8RHGB manage_merchant:06MFAZZX6E',
    }
  end
end
