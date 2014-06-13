Crisp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  GoCardless.environment = :sandbox
  GoCardless.account_details = { 
    :app_id     => '000WC7NCWKK8HV1D9YSJZJK1K9WFQYD88YBBEPYE5E518MXEBTVYZ43RS3ANV5QN',
    :app_secret => '3WTRHN958T0B7K7JC33NY47HV9RMNJZMYWW3XXAJ4MCJAWJ7V1V3BFJ6NXQBGHWY',
    :token      => 'J3BFFTDSH0EJAR6NPF1R0PES3Y7WTEG0X79MFT7XGDAH9S0W19NMMVYFR0RYBV5V manage_merchant:072VC7XEC5',
  }
end

