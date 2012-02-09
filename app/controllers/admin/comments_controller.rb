class Admin::CommentsController < Admin::InheritedResourceController
  def edit
    options[:fields] = [:comments]
    super
  end

  def show
    options[:fields] = [:comments, :postedByName, :created_at, :is_blocked]
    super
  end

  def new
    options[:fields] = [:comments, :created_at]
    super
  end

  def index
    options[:fields] = [:comments, :user_id, :created_at]
    options[:associations] = { :belongs_to => { :user => :user_id } }
    options[:paginate] = true
    options[:config].search_terms = [:comments]
    super
  end

  def update
    update! { @comment.expire } # TODO shouldn't this be in the model?
  end

  private

  def set_current_tab
    @current_tab = 'Comments'
  end
end
