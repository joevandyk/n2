APP_CONFIG = ActiveSupport::HashWithIndifferentAccess.new
APP_CONFIG['use_view_objects'] = true
ActionMailer::Base.default_url_options[:host] = 'http://test.com'

Time.zone = APP_CONFIG['time_zone'] || 'Pacific Time (US & Canada)'

# Use Bit.ly version 3 API
if defined?(Bitly)
  Bitly.use_api_version_3
end
