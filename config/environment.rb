# force Rails into production mode when                          
# you don't control web/app server and can't set it the proper way                  
# ENV['RAILS_ENV'] ||= 'production'

#config.force_ssl = true
#config.middleware.use Rack::SslEnforcer,
#  :redirect_to => 'https://example.com',    # For when behind a proxy, like nginx
#  :only => [/^\/admin\//, /^\/authors\//],  # Force SSL on everything behind /admin and /authors
#  :strict => true                           # Force no-SSL for everything else

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
