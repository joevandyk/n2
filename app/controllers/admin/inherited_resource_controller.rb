class Admin::InheritedResourceController < AdminController
  inherit_resources

  def index
    options[:items] = collection
    render 'shared/admin/index_page', :locals => options
  end

  def new
    options[:item] = resource_class.new
    render 'shared/admin/new_page', :locals => options
  end

  def show
    options[:item] = resource
    render 'shared/admin/show_page', :locals => options
  end

  def edit
    options[:item] = resource
    render 'shared/admin/edit_page', :locals =>  options
  end

  private

  def options
    @options ||= { :model => resource_class, :fields => {}}
  end

  def redirect_url
    polymorphic_url([:admin, resource])
  end

  def collection
    if options[:paginate] == true
      resource_class.paginate(:page => params[:page], :per_page => 20, :order => 'id desc')
    else
      super
    end
  end
end
