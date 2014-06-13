ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtpout.europe.secureserver.net",
  :port                 => 3535,
  :domain               => 'localhost',
  :user_name            => 'noreply@crispcleaners.co.uk',
  :password             => 'guardian',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }


ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#ActionMailer::Base.register_interceptor(MailInterceptor) if Rails.env.development?
