Rails.application.config.middleware.use OmniAuth::Builder do
  use OmniAuth::Builder do

    ExternalAuthSite.all.each do |site|
      provider site.name.to_sym, :setup => lambda { |env|
        current_domain = env['n2.domain']
        auth_info = ExternalAuthKey.load(site.name)
        raise "No #{ site.name } authentication provided for this site (#{ Site.current.try(:domain) })!" if auth_info.blank?
        env['omniauth.strategy'].options[:client_id]     = auth_info.key
        env['omniauth.strategy'].options[:client_secret] = auth_info.secret
      }
    end
  end
end
