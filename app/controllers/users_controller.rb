class UsersController < ApplicationController
  cache_sweeper :profile_sweeper, :only => [:update_bio]
  cache_sweeper :user_sweeper, :only => [:create, :link_user_accounts]

  ###before_filter :ensure_authenticated_to_facebook, :only => :link_user_accounts
  before_filter :find_page_user, :only => [:edit, :update]
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :enable_iframe_urls, :only => [:current]
  before_filter :set_meta_klass, :only => [:index]

  access_control do
    allow all, :to => [:index, :show, :feed, :account_menu, :current]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :update_bio, :dont_ask_me_for_email, :dont_ask_me_invite_friends, :invite]
    allow :identity_user, :of => :page_user, :to => [:edit, :update]
  end

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    case params[:top]
      when 'daily'
        @scores = Score.daily_scores
        @current_sub_tab = 'daily'
      when 'weekly'
        @scores = Score.weekly_scores
        @current_sub_tab = 'weekly'
      when 'monthly'
        @scores = Score.monthly_scores
        @current_sub_tab = 'monthly'
      when 'yearly'
        @scores = Score.yearly_scores
        @current_sub_tab = 'yearly'
      when 'alltime'
        @scores = Score.alltime_scores
        @current_sub_tab = 'alltime'
      else
        @scores = Score.weekly_scores
        @current_sub_tab = 'weekly'
    end
    respond_to do |format|
      format.html { @paginate = false }
      format.json { @users = User.refine(params) }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.active.find(params[:id])

    if @user.user_profile.update_attributes(params[:user][:user_profile]) and @user.update_attributes(params[:user])
      flash[:success] = "Successfully updated your settings."
  		redirect_to user_path(@user)
    else
      flash[:error] = "Could not update your settings as requested. Please try again."
      render :edit
    end
  end

  def feed
    render :partial => "pfeeds/pfeed_list", :locals => {:feed_collection => current_user.pfeed_inbox}, :layout => 'application'
  end

  def new
    store_location params[:return_to] if params[:return_to]
    @user = User.new
  end

  def create
    unless params[:user].present?
      @user = User.new
      render :new
      return false
    end
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default(root_url)
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      set_facebook_session unless facebook_session.present?
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    if canvas?
      redirect_top session[:return_to] || root_url:canvas => true)
      session[:return_to] = nil
    else
      redirect_back_or_default(root_url)
    end
  end

  def show
    @user = User.active.find(params[:id])
    @activities = @user.activities.active.find(:all, :limit => 7, :order => "created_at desc")
    @articles = @user.articles.active.published.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
    @paginate = true
    @is_owner = current_user && (@user.id == current_user.id)
    set_current_meta_item @user
    respond_to do |format|
      format.html
      format.atom { @actions = @user.newest_actions }
    end
  end

  def invite
    flash[:error] = "User invites is currently disabled"
    redirect_to root_url and return


    @success = false
    if request.post?
    	if params['action'] == 'invite' and params['ids'].present?
    		flash[:notice] = "Successfully invited your friends."
    		@fb_user_ids = params['ids']
    		@success = true
    	end
    end
  end

  def dont_ask_me_for_email
    if current_user_profile.update_attribute( :dont_ask_me_for_email, true)
  		flash[:success] = "We will no longer ask you to enable email notifications."
  		redirect_to root_url
    else
  		flash[:error] = "Could not update your notification settings"
  		redirect_to root_url
  	end
  end

  def dont_ask_me_invite_friends
    if current_user_profile.update_attribute( :dont_ask_me_invite_friends, true)
  		flash[:success] = "We will no longer ask you to invite your friends."
  		redirect_to root_url
    else
  		flash[:error] = "Could not update your reminder setting for invite friends"
  		redirect_to root_url
  	end
  end

  def update_bio
    if request.post?
      @profile = current_user_profile
      @profile.bio = @template.linkify @template.sanitize_user_bio params['bio']
      if @profile.save
    		flash[:success] = "Successfully edited your bio."
    		redirect_to user_path(@profile.user)
      else
    		flash[:error] = "Could not update your bio."
    		redirect_to user_path(@profile.user)
    	end
    end
  end

  def account_menu
    respond_to do |format|
      format.js
      format.html { redirect_to current_user }
    end
  end

  def current
    respond_to do |format|
      format.js
    end
  end

  def link_twitter_account

  end

  def set_auto_discovery_rss
    unless params[:id].nil?
      @user = User.active.find(params[:id])
      @auto_discovery_rss = user_path(@user, :format => :atom)
    else
      @auto_discovery_rss = stories_path(:format => :atom)
    end
  end

  private

  def check_valid_user
    redirect_to root_url and return false unless current_user == User.active.find(params[:id])
  end

  def find_page_user
    @page_user ||= User.active.find(params[:id])
  end

  def set_meta_klass
    set_current_meta_klass User
  end

end
