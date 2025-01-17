source 'https://rubygems.org'

# The following line is necessary to allow RVM choosing the correct ruby version. RVM 2.0 will probably be able to interpret the "~>" symbol and we will be able to safely remove the "#ruby=2.7.1" line.
#ruby=2.7.1
ruby '~> 2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1', '>= 6.1.7.3'

gem 'rubyzip', '~> 1.3.0'
gem 'loofah', '~> 2.19.1'
gem 'rails-html-sanitizer'
gem 'rack', '~> 2.2.6'
gem 'ffi', '>= 1.9.24'
gem "nokogiri", "~> 1.14.3"
gem "actionview"
gem "rake", '~> 13.0', '>= 13.0.6'
gem 'activestorage'
gem 'actionpack'
gem 'activesupport'
gem "mail", "~> 2.8.1"
gem "i18n", "~> 1.13.0"

# Use Active record session store
gem 'activerecord-session_store'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.0.4'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

gem "kaminari"
#gem "schema_plus"

gem 'cancancan'
gem "devise", "~> 4.9"
gem 'devise_invitable', '~> 2.0.0'
gem "paper_trail", '~> 14.0'

gem 'sql-parser'

# Iconography
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.8'

# Prawn to PDF
gem 'prawn'
gem 'prawn-table' 
gem 'prawn-rails'
gem 'odf-report'
gem 'clamsy', :git => 'https://github.com/gems-uff/clamsy.git', :branch => 'rails5'

# Redcarpet for Readme MarkDown (or README.md)
gem 'redcarpet' 

# Active scaffold support for Rails 3
gem 'active_scaffold', :git => 'https://github.com/activescaffold/active_scaffold.git'
gem 'active_scaffold_duplicate', '>= 1.1.0'
gem 'recordselect'

#Date Validation Plugin
gem 'validates_timeliness', '~> 3.0.14'

# Menu
gem 'simple-navigation'

# Notification
gem 'rufus-scheduler'

# Image
gem 'carrierwave', '~>2.2.2'
gem 'carrierwave-activerecord', :git => 'https://github.com/gems-uff/carrierwave-activerecord.git', :branch => 'rails61'


group :development, :test do
# Use SQLite database for development
  gem 'sqlite3'

  # Prints Ruby object in full color
  gem 'awesome_print'

  # View a better error page
  gem 'binding_of_caller'
  gem 'better_errors'
  
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Open /letter_opener in the browser to view 'sent' emails
  gem 'letter_opener_web'

  # Create entity-relationship diagram
  gem "rails-erd"

  # HTTP server toolkit
  gem 'webrick'
  gem 'spring'
end

group :test do
  # Test runner
  gem 'rspec-rails'

  # Fixtures replacement
  gem 'factory_bot_rails'
  
  # Suport 'have' syntax of rspec
  gem 'rspec-collection_matchers'

  # Simpler specs
  gem 'shoulda-matchers'

  # Clean database for every test
  gem 'database_cleaner-active_record'

  # Measure code coverage
  gem 'simplecov'
end

# Notify exceptions
gem 'exception_notification', '~> 4.5'
group :production do
  gem 'mysql2', '~> 0.5.4'
end

gem 'json'
gem 'rdoc'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
