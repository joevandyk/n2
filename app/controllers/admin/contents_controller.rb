class Admin::ContentsController < Admin::InheritedResourceController
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def show
    options[:paginate] = true
    options[:fields] = [:title, :user_id, :url, :caption, :content_image, :source, :score, :comments_count, :is_blocked, :created_at]
    options[:associations] = { :belongs_to => { :user => :user_id , :source => :source}, :has_one => { :content_image => :content_image}}
    options[:config].search_terms = [:title, :url, :caption]
    super
  end

  # Use the app/views/admin/contents/new,edit view
  def new; new!; end
  def edit; edit!; end

  def index
    options[:fields] = [:title, :user_id, :score, :comments_count, :is_blocked, :created_at]
    options[:associations] = { :belongs_to => { :user => :user_id, :source => :source } }
    options[:paginate] = true
    options[:config].search_terms = [:title, :caption]
    super
  end

  def create
    @content = Content.new(params[:content])
    @content.user = current_user
    @content.tag_list = params[:content][:tags_string]
    if params[:content][:image_url].present?
      @content.build_content_image({:url => params[:content][:image_url]})
    end
    create!
  end

  private

  def set_current_tab
    @current_tab = 'contents'
  end
end
