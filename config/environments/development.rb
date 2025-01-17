# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

Sapos::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Allow the notifier to send emails
  config.should_send_emails = Rails.const_defined?('Server') 

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false
  config.public_file_server.enabled = false

  # Configure ActionMailer
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # config.action_mailer.delivery_method = :sendmail
  # config.action_mailer.sendmail_settings = {:location => '/usr/sbin/sendmail' }

  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

  # config.action_mailer.smtp_settings = {
  #     :address              => "smtp.gmail.com",
  #     :port                 => 587,
  #     :domain               => "gmail.com",
  #     :user_name            => "everton.moreth@gmail.com",
  #     :password             => "gjoao.pe,feijao!O",
  #     :authentication       => "plain",
  #     :enable_starttls_auto => true
  # }

  #this line was added to replace the quiet_assets gem functionality
  config.assets.quiet = true

  config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: '[SAPOS: Error] ',
      sender_address: %{"SAPOS Exception Notifier" <erro-sapos@sapos.ic.uff.br>},
      exception_recipients: %w{letter@saposletteropener.com}
    }
end
