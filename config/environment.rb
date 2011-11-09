require 'thread'
require File.join(File.dirname(__FILE__), 'boot')

# Reserved names for friendly_id slugs
RESERVED_NAMES = ["admin", "administrator", "update", "delete", "show", "create", "new", "newscloud", "n2", "edit"] unless defined?(RESERVED_NAMES)

require "#{RAILS_ROOT}/lib/iframe_rewriter.rb"
require "#{RAILS_ROOT}/lib/facebook_request.rb"


Rails::Initializer.run do |config|
  config.middleware.use Rack::FacebookRequest
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers #{RAILS_ROOT}/app/workers )

  config.active_record.observers = :message_observer, :comment_observer, :flag_observer

  # TODO use UTC
  config.time_zone = 'Pacific Time (US & Canada)'

  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache"
end

if FileTest.exists?("#{RAILS_ROOT}/config/smtp.yml")
  smtp = YAML::load(File.open("#{RAILS_ROOT}/config/smtp.yml"))
  ActionMailer::Base.smtp_settings = smtp[Rails.env].with_indifferent_access
end

require "#{RAILS_ROOT}/lib/parse.page.rb"
