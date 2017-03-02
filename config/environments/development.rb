Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  #config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true
  config.stripe.secret_key = "sk_test_AyNDRGiWrBva0qJe749H7vai"
  config.stripe.publishable_key = "pk_test_od6qMjEWQDqZI90OI4W9vh8g"
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  ENV['GEOIP_KEY']  = "bc7903c99d1ea532f709cfef316d11b458d0ec41f56b43f07fbcf6f7e2ba2e27"
  ENV['GOOGLE_KEY'] = "AIzaSyA7B-_hoQVA07h-qSd3E-HXxyXnM9W4zC8"
  ENV['ABN_GUID'] = "c7b82124-b224-4d3e-ac54-f008ae5f6ab7"
  ENV["LINKEDIN_CLIENT_ID"] = "75jjzveiib8wnq"
  ENV["LINKEDIN_CLIENT_SECRET"] = "loCsi3Cks6yHSRrY"
  ENV['PUBLISHABLE_KEY'] = "pk_test_od6qMjEWQDqZI90OI4W9vh8g"
  ENV['SECRET_KEY'] = "sk_test_AyNDRGiWrBva0qJe749H7vai"
  ENV['FACEBOOK_KEY'] = "1039814866107032"
  ENV['FACEBOOK_SECRET'] = "75d10afcc168acb00d6cc9b07418bb4f"
  ENV['OFFICE_ID'] = "38c34ecf-fef2-4c16-ae62-c690dcd5aa5f"
  ENV['OFFICE_SECRET'] = "QFWJy4UHDLbCubZnE1iWrmA"
  ENV["INTERCOM_APP_ID"] = "ywfyj3d0"


  config.action_mailer.default_url_options = { :host => 'localhost' }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true

  config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "gmail.com",
      :user_name            => "agile.jjp@gmail.com",
      :password             => "JoenerPreagola0428",
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }

  config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
          :bucket => ENV['AWS_BUCKET'],
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      },
      :s3_protocol => "http",
      :s3_endpoint => "s3-ap-southeast-2.amazonaws.com",
      :s3_host_name => "s3-ap-southeast-2.amazonaws.com",
      :server => ENV['SERVER'],
      :s3_region => ENV['AWS_REGION'],
      :s3_host_alias => ENV['AWS_BUCKET'],
      :url =>':s3_domain_url',
      :path => '/:class/:attachment/:id_partition/:style/:filename'

  }
end
