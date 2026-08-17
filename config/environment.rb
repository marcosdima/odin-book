# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors = true
config.action_mailer.default_url_options = { host: "https://odin-book-j6ha.onrender.com/" }

config.action_mailer.smtp_settings = {
  address: "smtp-relay.brevo.com",
  port: 587,
  domain: "smtp-relay.brevo.com",
  user_name: ENV["BREVO_SMTP_LOGIN"],
  password: ENV["BREVO_SMTP_KEY"],
  authentication: :plain,
  enable_starttls_auto: true
}