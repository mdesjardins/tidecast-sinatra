APP_ROOT = File.expand_path('../..', __FILE__) unless defined? APP_ROOT
$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib'))

ENV['RACK_ENV'] ||= 'development'

require "sinatra/json"
require 'data_mapper'
require 'dm-serializer'
require 'noaa'
require 'models'

# Run all the initializers
Dir["#{APP_ROOT}/config/initializers/**/*.rb"].each { |i| require i }

# Include all the controllers and models
# libraries = %w| models
#                 controllers |
# Dir["#{APP_ROOT}/lib/{#{libraries.join(',')}}/**/*.rb"].each { |r| require r }

# if development?
#   require 'ruby-debug'

#   Debugger.settings[:autoeval] = true
#   Debugger.settings[:autolist] = 1
#   Debugger.settings[:reload_source_on_change] = true
# end