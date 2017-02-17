Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = true #ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true




  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
  config.stripe.secret_key = "sk_test_AyNDRGiWrBva0qJe749H7vai"
  config.stripe.publishable_key = "pk_test_od6qMjEWQDqZI90OI4W9vh8g"

  # Do not dump schema after migrations.

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

  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_url_options = { :host => 'etendercon.herokuapp.com' }
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
      :s3_endpoint => ENV['AWS_SERVER'],
      :s3_host_name => ENV['AWS_SERVER'],
      :server => ENV['SERVER'],
      :s3_region => ENV['AWS_REGION'],
      :s3_host_alias => ENV['AWS_BUCKET']

  }
end
