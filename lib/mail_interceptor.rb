class MailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "rubyonrails3@gmail.com"
  end
end
