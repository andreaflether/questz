# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'bootsnap', '>= 1.6.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0', '>= 6.0.2'
gem 'sass-rails', '~> 5.0'
# gem 'sqlite3'
gem 'pg'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'rake'

# Custom gems for this project
gem 'active_link_to'
gem 'activity_notification'
gem 'acts_as_commentable'
gem 'acts_as_follower', github: 'tcocca/acts_as_follower', branch: 'master'
gem 'acts-as-taggable-on', '~> 7.0'
gem 'acts_as_votable'
gem 'cancancan'
gem 'carrierwave', '~> 2.0'
gem 'chartkick'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'dependent-fields-rails'
gem 'devise'
gem 'enum_help'
gem 'faker'
gem 'friendly_id', '~> 5.4.0'
gem 'groupdate'
gem 'has_scope'
gem 'high_voltage', '~> 3.1'
gem 'honor'
gem 'humanize'
gem 'impressionist', '~> 1.6.1'
gem 'inline_svg'
gem 'kaminari'
gem 'language_filter'
gem 'meta-tags'
gem 'mini_portile2'
gem 'public_activity'
gem 'ransack'
gem 'simple_form'
gem 'social-share-button'
gem 'stringex'
gem 'trix-rails', require: 'trix'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.0'
  gem 'rspec-rails', '>= 6.0.4'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'tty-spinner'
end

group :development do
  gem 'annotate'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'guard', '~> 2.15'
  gem 'guard-livereload', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-livereload'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem "dockerfile-rails", ">= 1.5", :group => :development
