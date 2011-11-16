class ClassifiedsController < ApplicationController
  cache_sweeper :classified_sweeper, :only => [:create, :update]

  before_filter :find_classified, :only => [:show, :edit, :update, :set_status]
  before_filter :set_categories, :only => [:new]
  before_filter :set_meta_klass, :only => [:index]
  
  access_control do
    allow all, :to => [:index, :categories]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :borrowed_items, :my_items]
    allow anonymous, :to => [:show, :categories], :if => :classified_allows_anonymous_users?
    allow :allowed, :of => :classified, :to => [:show]
    allow :owner, :of => :classified, :to => [:edit, :update, :set_status]
  end

  before_filter :set_current_tab

  def index
    @current_sub_tab = 'Browse'
    # to do - implement recently viewed scope or method for current user 
    @recently_viewed_classifieds = Classified.newest 5
    @page = params[:page]
    @paginate = true
    @classifieds = Classified.for_user(current_user).paginate :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html
      format.json { render :partial => 'shared/classifieds', :locals => { :classifieds => Classified.filtered_results(params, current_user) } }
    end
  end

  def new
    @current_sub_tab = 'New Item'
    @classified = Classified.new
    @keywords = params[:keywords]
    @category = params[:category] || 'Books'
    # @classified.classified_board = @classified_board if @classified_board.present?
    #@classifieds = Classified.active.newest
  end

  def create
    @classified = Classified.new(params[:classified])
    #@classified.tag_list = params[:classified][:tags_string]
    @classified.user = current_user

    if @classified.valid? and current_user.classifieds.push @classified
      if @classified.post_wall?
        session[:post_wall] = @classified
      end      
    	flash[:success] = "Thank you for posting your item!"
    	redirect_to @classified
    else
    	render :new
    end
  end

  def show
    @classified = Classified.active.find(params[:id])    
    @current_sub_tab = 'Show'
    set_current_meta_item @classified
  end

  def edit
    @current_sub_tab = 'Edit'
    @classified = Classified.active.find(params[:id])
  end
  
  def update
    @classified = Classified.active.find(params[:id])
    if @classified.valid? and @classified.update_attributes(params[:classified])
      flash[:success] = "Successfully updated your listing!"
      redirect_to classified_path(@classified)
    else
    	flash[:error] = "Could not update your listing. Please fix the errors and try again."
    	render :edit
    end
  end
  

  def my_items
    @current_sub_tab = 'My Items'
    @classifieds = current_user.classifieds.active
  end

  def borrowed_items
    @current_sub_tab = 'My Borrowed Items'
  end

  def set_status
    if @classified.valid_user_events.include? params[:status].to_sym
    	method = "#{params[:status]}!".to_sym
    	if @classified.send(method)
    		flash[:success] = "Successfully updated your classified"
    		redirect_to @classified
    	else
    		flash[:error] = "Could not update your classified"
    		redirect_to @classified
    	end
    else
      flash[:error] = "Invalid action for this classified"
      redirect_to @classified
    end
  end

  def categories
    category_name = CGI.unescape(params[:category])
    @category = Classified.categories.find_by_name(category_name)
    if @category
    	@classifieds = Classified.in_category(@category.id)
    else
    	flash[:error] = "Invalid category"
    	redirect_to classifieds_path
    end
  end

  private 

    def set_current_tab
      @current_tab = 'classifieds'
    end

    def access_denied
      store_location
      if current_user
      	flash[:notice] = I18n.translate('sessions.invalid_permissions')
      	redirect_to classifieds_path
      else
      	flash[:notice] = I18n.translate('sessions.access_denied')
      	redirect_to new_session_path
      end
    end

    def find_classified
      @classified ||= Classified.find(params[:id])
    end

    def classified_allows_anonymous_users?
      @classified.is_allowed? nil
    end
    
    def set_categories
      @categories = Newscloud::AmazonSearch.categories
    end

    def set_meta_klass
      set_current_meta_klass Classified
    end

end
