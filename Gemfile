source 'https://rubygems.org'

gem 'nesty','~>1.0'
gem 'docopt', '~>0.5'
gem 'mini_exiftool'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do

  require 'rbconfig'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'terminal-notifier-guard', require: false

  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'libnotify', '~> 0.8', require: false

  elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    gem 'win32console', require: false
    gem 'rb-notifu', '>= 0', require: false
  end
  
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rspec', ">= 0"
  gem 'bundler', ">= 0"
end
