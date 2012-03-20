require 'yaml'
require 'resque'
require 'resque/failure/airbrake'
require 'resque/failure/redis'
require 'resque/failure/multiple'

rails_root = (defined?(Rails) && Rails.root) || File.expand_path(File.dirname(__FILE__) + '/../..')
rails_env = ENV['RAILS_ENV'] || (defined?(Rails) && Rails.env.to_s) || 'development'
ENV['RAILS_ENV'] ||= rails_env

# HACK for when we use this initializer to spawn workers shedulers and resque web
unless defined?(APP_CONFIG)
  APP_CONFIG = {}
end

resque_base_file = File.join(rails_root, 'config/resque.yml')
resque_file = File.exists?(resque_base_file) ? resque_base_file : (resque_base_file.to_s + '.sample')
resque_config = YAML.load_file(resque_file)
Resque.redis = resque_config[rails_env]
APP_CONFIG['redis'] = resque_config[rails_env]

app_name = rails_root.to_s =~ %r(/([^/]+)/(current|release)) ? $1 : nil
APP_CONFIG['namespace'] = app_name
Resque.redis.namespace = "resque:#{app_name}" if app_name

if defined?(ActiveRecord)
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

# If we're in rails, set the global redis connection
#if defined?(Newscloud)
#  $redis = Newscloud::Redcloud.create
#end

require 'resque_scheduler'
resque_schedule_base_file = File.join(rails_root, 'config/resque_schedule.yml')
resque_schedule_file = File.exists?(resque_schedule_base_file) ? resque_schedule_base_file : (resque_schedule_base_file.to_s + '.sample')
resque_schedule_config = YAML.load_file(resque_schedule_file)
Resque.schedule = resque_schedule_config


# Failure Backends Setup
Resque::Failure::Airbrake.configure do |config|
  config.api_key = Airbrake.configuration.api_key
end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
Resque::Failure.backend = Resque::Failure::Multiple
