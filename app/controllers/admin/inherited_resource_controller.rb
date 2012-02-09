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
    @options ||= {
      :model => resource_class,
      :fields => {},
      :config => OpenStruct.new,
      :associations => {},
      :pagination => false
    }
  end

  def redirect_url
    polymorphic_url([:admin, resource])
  end

  def collection
    relation = super
    if options[:paginate] == true
      relation = resource_class.paginate(:page => params[:page], :per_page => 20, :order => 'id desc')
    end

    @search = relation.search(params[:q])
    @search.result
  end
end
