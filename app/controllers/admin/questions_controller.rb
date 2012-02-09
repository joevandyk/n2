class Admin::QuestionsController < Admin::InheritedResourceController
  skip_before_filter :admin_user_required

  def index
    options[:fields] = [:question, :details, :user_id, :votes_tally, :comments_count, :created_at]
    options[:associations] = { :belongs_to => { :user => :user_id } }
    options[:paginate] = true
    super
  end

  # Use the views, not the scaffold
  def new;   new!;   end
  def edit;  edit!;  end

  private

  def set_current_tab
    @current_tab = 'questions'
  end
end
