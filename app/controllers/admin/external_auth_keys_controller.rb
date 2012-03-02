class Admin::ExternalAuthKeysController < AdminController
  def index
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => ExternalAuthKey.all,
      :model => ExternalAuthKey,
      :fields => [:external_site_type, :key, :secret]
    }
  end

  def new
    render_new
  end

  def edit
    @external_auth_key = ExternalAuthKey.find(params[:id])
    render_edit @external_auth_key
  end

  def update
    @external_auth_key = ExternalAuthKey.find(params[:id])
    if @external_auth_key.update_attributes(params[:external_auth_key])
      flash[:success] = "Successfully updated your external authentication."
      redirect_to [:admin, @external_auth_key]
    else
      flash[:error] = "Could not update your external authentication as requested. Please try again."
      render_edit @external_auth_key
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => ExternalAuthKey.find(params[:id]),
      :model => ExternalAuthKey,
      :fields => [:external_site_type, :key, :secret]
    }
  end

  def create
    @external_auth_key = ExternalAuthKey.new params[:external_auth_key]
    if @external_auth_key.save
      flash[:success] = "Successfully created your new external authentication!"
      redirect_to [:admin, @external_auth_key]
    else
      flash[:error] = "Could not create your external authentication, please try again"
      render_new @external_authentication
    end
  end

  def destroy
    @newswire = ExternalAuthKey.find(params[:id])
    @newswire.destroy

    redirect_to :action => :index
  end

  private

  def render_new external_auth_key = nil
    external_auth_key ||= ExternalAuthKey.new

    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => external_auth_key,
      :model => ExternalAuthKey,
      :fields => [:external_site_type, :key, :secret]
    }
  end

  def render_edit external_auth_key
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => external_auth_key,
      :model => ExternalAuthKey,
      :fields => [:external_site_type, :key, :secret]
    }
  end


  def set_current_tab
    @current_tab = 'external_auth_keys'
  end

end
