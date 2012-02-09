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
      :paginate => false
    }
  end

  def redirect_url
    polymorphic_url([:admin, resource])
  end

  def collection
    return @collection if defined?(@collection)
    relation = super

    @search = relation.search(params[:q])
    relation = @search.result

    if options[:paginate] == true
      relation = relation.paginate(:page => params[:page], :per_page => 20, :order => 'id desc')
    end

    if params[:sort]
      relation = relation.except(:order).sorted(params[:sort])
    end

    @collection = relation
  end
end
