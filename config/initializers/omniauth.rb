Rails.application.config.middleware.use OmniAuth::Builder do
  use OmniAuth::Builder do

    provider :facebook, :setup => lambda { |env|
      current_domain = env['n2.domain']
      auth_info = ExternalAuthKey.load('facebook')
      raise "No facebook authentication provided for this site!" if auth_info.blank?
      env['omniauth.strategy'].options[:client_id]     = auth_info.key
      env['omniauth.strategy'].options[:client_secret] = auth_info.secret
    }

    # Same for twitter, I believe?
  end
end
