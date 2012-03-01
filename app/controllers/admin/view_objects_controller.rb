class Admin::ViewObjectsController < AdminController
  before_filter :set_featured_types, :only => [:edit, :update]

  admin_scaffold :view_object do |config|
    config.index_fields = [:name, :view_object_template_id]
    #config.show_fields = [:name, :view_object_template_id]
    config.actions = [:index]
    config.associations = { :belongs_to => { :view_object_template => :view_object_template_id } }
  end

  def new
    @view_object = ViewObject.new
    @view_object_setting = Metadata::ViewObjectSetting.new
    @view_object_setting.metadatable = @view_object
  end

  def create
    raise params.inspect
  end
  
  def show
    @view_object = ViewObject.find(params[:id])
    @view_object_setting = @view_object.setting
  end

  def clone
    @parent_view_object = ViewObject.find(params[:id])
    @view_object = @parent_view_object.dup
    @view_object_setting = @parent_view_object.setting.dup
    @view_object_setting.metadatable = @view_object
    render :new
  end
  
  def edit
    @view_object = ViewObject.find(params[:id])
    @view_object_setting = @view_object.setting
    raise @view_object_setting.inspect if @view_object_setting.kommands.size > 1
  end

  def update
    vo_params = params[:view_object]
    vos_params = params[:view_object_setting]
    @view_object = ViewObject.find(params[:id])
    @view_object_setting = @view_object.setting
    #@view_object.name = vo_params["key_name"] # TODO: add this to setting, not view object
    @view_object_setting.locale_title = vos_params["locale_title"] # TODO: switch helpers to use find locale or use this default value
    @view_object_setting.locale_subtitle = vos_params["locale_subtitle"]
    @view_object_setting.use_post_button = !! vos_params["use_post_button"]
    @view_object_setting.cache_disabled = !! vos_params["cache_disabled"]
    @view_object_setting.klass_name = vos_params["klass_name"]
    #@view_object_setting.version += 1
    kommand = {
      :method_name => vos_params[:kommand_name],
      :args => [vos_params[:kommand_limit].to_i]
    }
    @view_object_setting.kommands = [kommand]
    if @view_object.valid? and @view_object_setting.valid? and @view_object.save and @view_object_setting.save
      @view_object.expire
      flash[:success] = "Successfully updated your view object"
      redirect_to [:admin, @view_object]
    else
      flash[:error] = "Could not update your view object. Please fix any errors and try again."
      render :edit
    end
  end

  def create
    raise params.inspect
  end
  
  def edit_curated
    @view_objects = ["v2_double_col_feature_triple_item", "v2_double_col_triple_item", "v2_triple_col_large_2"].map {|name| ViewObjectTemplate.find_by_name(name) }.map(&:view_objects).flatten.select {|vo| vo.setting.kommands.empty? }
    @view_object = ViewObject.find(params[:id])
    @view_object_template = @view_object.view_object_template

    unless @view_objects.include? @view_object
      flash[:error] = "Invalid view object"
      redirect_to admin_path and return
    end
  end

  def update_curated
    data = params['featured_items']
    view_object = ViewObject.find(params[:id])

    render :json => {:error => "Invalid Type"}.to_json and return unless data.select {|i| not @featurables.map {|f| f[1].classify }.include?(i.sub(/-[0-9]+$/,'').classify) }.empty?

    view_object.setting.dataset = data.map {|i| i.split(/-/) }.map{|i| [i[0].classify, i[1]] }
    view_object.setting.save
    view_object.expire

    render :json => {:success => "Success!"}.to_json and return
  end

  private

    def set_featured_types
      @featurables ||= [['Stories', 'contents'], ['Ideas', 'ideas'], ['Questions', 'questions'], ['Resources', 'resources'], ['Events', 'events'], ['Galleries', 'galleries'], ['Forums', 'forums'], ['Topics', 'topics'], ['Prediction Groups', 'prediction_groups'], ['Prediction Questions', 'prediction_questions']]
    end

end
