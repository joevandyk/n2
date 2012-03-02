class PredictionGroupsController < ApplicationController
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :set_meta_klass, :only => [:index]

  cache_sweeper :prediction_sweeper, :only => [:create, :update, :destroy]

  access_control do
    allow all, :to => [:index, :show, :tags, :play]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @prediction_groups = PredictionGroup.active.approved.currently_open.paginate :page => params[:page], :per_page => PredictionGroup.per_page, :order => "created_at desc"
    @current_sub_tab = 'Browse'
  end

  def new
   @current_sub_tab = 'New Prediction Group'
   @prediction_group = PredictionGroup.new
  end

  def create
    @prediction_group = PredictionGroup.new(params[:prediction_group])
    @prediction_group.tag_list = params[:prediction_group][:tags_string]
    @prediction_group.user = current_user
    @prediction_group.is_approved = current_user.is_moderator?

    if @prediction_group.valid? and current_user.prediction_groups.push @prediction_group
      flash[:success] = t('predictions.create_prediction_group')
      play
    else
      @prediction_groups = PredictionGroup.approved.currently_open.active.newest
      render :new
    end
  end

  def show
    self.play
  end

  def play
    if params[:id].nil?
      # to do - get first open
      @prediction_group = PredictionGroup.approved.currently_open.first
      #:all, :order => "random()"
    else
      @prediction_group = PredictionGroup.find(params[:id])
    end

    unless @prediction_group
      flash[:error] = "Could not find the prediction group."
      redirect_to prediction_groups_path and return
    end

    tag_cloud @prediction_group
    set_outbrain_item @prediction_group
    set_current_meta_item @prediction_group
    @current_sub_tab = 'Predict'
    @previous_prediction_group = @prediction_group.previous
    @next_prediction_group = @prediction_group.next
    render :template => 'prediction_groups/show'
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @prediction_groups = PredictionGroup.active.tagged_with(tag_name, :on => 'tags').paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def set_meta_klass
    set_current_meta_klass PredictionGroup
  end

end
