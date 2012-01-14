class OauthController < ApplicationController
  before_filter :login_required

  def new
    session[:at]=nil
    if iframe_facebook_request?
      redirect_top authenticator.authorize_url(:scope => 'publish_stream,offline_access', :display => 'page')
    else
      redirect_to authenticator.authorize_url(:scope => 'publish_stream,offline_access', :display => 'page')
    end
  end

  def create
    if params[:error].present?
      if params[:error][:type] == "OAuthAccessDeniedException" or params[:error_reason] == "user_denied"
        current_user.update_attribute(:fb_oauth_denied_at, Time.now)
      else
        Rails.logger.error "***FB OAUTH ERROR*** #{params.inspect}"
      end
    else
      mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
      session[:at]=mogli_client.access_token
      current_user.update_attribute(:fb_oauth_key, mogli_client.access_token)
    end
    if iframe_facebook_request?
    	redirect_top root_url(:canvas => true)
    else
      redirect_to root_url
    end
  end

  def authenticator
    if Metadata::Setting.find_setting('app_id').present?
      app_id = Metadata::Setting.find_setting('app_id').value
    else
      app_id ||= APP_CONFIG['facebook_application_id']
    end
    @authenticator ||= Mogli::Authenticator.new(app_id, Facebooker.secret_key, oauth_callback_path(:only_path => false, :canvas => iframe_facebook_request?))
  end
end
