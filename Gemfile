source 'https://rubygems.org'

#ruby '2.2.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
gem 'execjs'
gem 'therubyracer'
gem 'dropzonejs-rails'


gem 'thin'

gem 'font-awesome-rails'
#gem 'savon', '~> 2.11.0'
gem 'rubyntlm', '~> 0.3.2'
# background process
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'rubyzip'

gem 'bootstrap-multiselect-rails'
gem 'dotenv-rails', :groups => [:development, :test,:production]

gem 'jquery-datatables-rails', '~> 3.4.0'

# intercom
gem 'intercom-rails'

# linkedin
#gem "linkedin-oauth2", "~> 1.0"
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'linkedin-scraper'

#gem 'bootstrap-wysihtml5-rails'

gem 'jspdf-rails'


# credit card
gem 'credit_card_validations'
gem 'stripe-rails'


# pdf
gem 'pdfkit'
#gem 'wicked_pdf'
#gem 'wkhtmltopdf-binary'
#gem 'wkhtmltopdf-installer'
gem 'prawn-rails'

# for uploading
gem 'paperclip'#, git: 'git://github.com/thoughtbot/paperclip.git'

# jquery file upload
gem 'jquery-fileupload-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-cookie-rails'

gem 'twilio-ruby' # for interacting with twilio
gem 'envyable' # for managing environment variables

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# ABN lookup
gem 'abn_search'

# Select option
gem 'select2-rails'

# google map
gem 'gmaps4rails'
gem 'geokit-rails'
#gem 'geocoder'
gem 'geocoder', :git => 'git://github.com/alexreisner/geocoder.git'
gem 'geo_ip'

gem 'timezone'
gem 'time_difference'

gem 'ruby_outlook'
gem 'oauth2', '~> 1.2'
gem 'activerecord-session_store'
gem 'fullcalendar-rails'
gem 'faraday'
gem 'little-plugger'
gem 'google-api-client', '0.8.2', require: 'google/api_client'
gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'responders', '~> 2.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails', '~> 3.5'
  gem 'capybara'
  gem 'factory_girl_rails'
  #gem 'guard-rspec'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end

