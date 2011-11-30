require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module N2
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.active_record.schema_format = :sql
    config.middleware.use OmniAuth::Builder do
      provider :facebook, '229907033745718', '27e95fa82642b9eda445576a38762b2a'
      #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
      #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
    end
  end
end
