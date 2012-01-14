class ApplicationController < ActionController::Base
  rescue_from Acl9::AccessDenied, :with => :access_denied

  include Newscloud::Util

  layout :detect_browser

  helper :all # include all helpers, all the time
  before_filter :set_iframe_status
  before_filter :set_p3p_header
  before_filter :set_current_tab
  before_filter :set_current_sub_tab
  before_filter :set_ad_layout
  before_filter :set_locale
  before_filter :set_outbrain_item
  before_filter :set_auto_discovery_rss
  before_filter :update_last_active
  before_filter :check_post_wall
  before_filter :verify_request_format

  helper_method :base_site_url
  helper_method :base_site_domain
  helper_method :facebook_session
  helper_method :current_facebook_user
  helper_method :get_setting
  helper_method :get_setting_value
  helper_method :setting_enabled?
  helper_method :get_ad_layout
  helper_method :iframe_facebook_request?
  helper_method :get_canvas_preference
  helper_method :canvas_url
  helper_method :replace_url_with_canvas_url
  helper_method :replace_text_with_canvas_urls
  helper_method :replace_text_with_urls
  helper_method :find_item_by_cache_id
  helper_method :get_current_meta_item
  helper_method :set_current_meta_item
  helper_method :get_current_meta_klass
  helper_method :set_current_meta_klass
  helper_method :page_title
  helper_method :klass_title
  helper_method :klass_description

  def newscloud_redirect_to(options = {}, response_status = {})
    @enable_iframe_hack = !! @iframe_status
    headers["Newscloud-Redirect"] = @enable_iframe_hack ? 'redirect' : 'static'
    rails_redirect_to options, response_status
  end
  alias_method :rails_redirect_to, :redirect_to
  alias_method :redirect_to, :newscloud_redirect_to


  # TODO:: get this working
  #def handle_unverifiedrequest
  #end

  # Facebooker workarounds
  def request_comes_from_facebook?() false end

  def logged_in_to_facebook_and_app_authorized
    if ensure_application_is_installed_by_facebook_user
      # filter_parameter_logging :fb_sig_friends # commenting out for now because it fails sometimes
    end
  end

  def check_post_wall
    @share_item = session.delete(:post_wall)
  end

  def set_p3p_header
    #required for IE in iframe FB environments if sessions are to work.
    headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
  end

  def set_facebook_session_wrapper
    begin
      set_facebook_session
      #session[:facebook_request] = true if request_comes_from_facebook? or params[:iframe_req].present?
    rescue
      return facebook_session_expired
    end
  end

  def set_current_tab
    @current_tab = false
  end

  def set_auto_discovery_rss url = nil
    @auto_discovery_rss ||= url || stories_path(:format => :atom)
  end

  def set_sponsor_zone name = nil, topic = 'default'
    if get_setting('sponsor_zones_enabled').try('enabled?')
      @sponsor_zone_code ||= Metadata::SponsorZone.get(name, 'default').try(:sponsor_zone_code)
      @sponsor_zone_topic ||= topic
    else
      @sponsor_zone_code = nil
      @sponsor_zone_topic = nil
    end
  end

  def set_outbrain_item item = nil
    if get_setting('outbrain_enabled').try('enabled?')
      @outbrain_item ||= item
    else
      @outbrain_item = nil
    end
  end

  def set_current_sub_tab
    @current_sub_tab = false
  end

  def load_top_stories
    @top_stories ||= Content.active.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "vote_count desc"
    })
  end

  def load_top_users
    @top_users ||= User.active.top.members
  end

  def load_contents
    @contents ||= Content.active.top_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
  end

  def load_newest_users
    @newest_users ||= User.active.newest
  end

  def load_top_discussed_stories
    @most_discussed_stories ||= Content.active.find( :all,
    	:limit    => 5,
    	:conditions => ["created_at > ?", 1.week.ago],
    	:order    => "comments_count desc"
    )
  end

  def load_top_ideas
    @top_ideas ||= Idea.active.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "vote_count desc"
    })
  end

  def load_featured_articles
    @featured_articles ||= Article.active.featured
  end

  def load_featured_comments
    @featured_comments ||= Comment.active.featured
  end

  def load_newest_articles
    @newest_articles ||= Article.active.published.newest 5
  end

  def load_newest_images
    @newest_images ||= Image.newest
    #@newest_images ||= Image.find(:all, :limit => 10, :order => "created_at desc")
  end

  def load_newest_videos
    @newest_videos ||= Video.newest
  end

  def load_newest_ideas
    @newest_ideas ||= Idea.active.newest 5
  end

  def load_featured_ideas
    @featured_ideas ||= Idea.active.featured
  end

  def load_featured_events
    @featured_events ||= Event.active.featured
  end

  def load_featured_resources
    @featured_resources ||= Resource.active.featured
  end

  def load_featured_items
    @featured_items ||= FeaturedItem.find_root_by_item_name('featured_template')
  end

  def load_newest_idea_boards
    @newest_idea_boards ||= IdeaBoard.active.newest 5
  end

  def load_newest_resource_sections
    @newest_resource_sections ||= ResourceSection.active.newest 5
  end

  def load_top_resources
    @top_resources ||= Resource.active.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "vote_count desc"
    })
  end

  def load_newest_resources
    @newest_resources ||= Resource.active.newest 5
  end

  def load_newest_newswires
    @newest_newswires ||= Newswire.newest 5
  end

  def load_top_events
    @top_events ||= Event.active.upcoming.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "vote_count desc"
    })
  end

  def load_newest_events
    @newest_events ||= Event.active.upcoming 5
  end

  def load_newest_announcements
    @newest_announcements ||= Announcement.newest 1
  end

  def load_ad_leaderboard
    @slot_widget_leaderboard = Metadata.get_ad_slot('leaderboard', 'default')
  end

  def load_ad_square
    @slot_widget_square = Metadata.get_ad_slot('square', 'default')
  end

  def load_ad_small_square
    @slot_widget_small_square = Metadata.get_ad_slot('small_square', 'default')
  end

  def load_ad_skyscraper
    @slot_widget_skyscraper = Metadata.get_ad_slot('skyscraper', 'default')
  end

  def load_ad_medium_rectangle
    @slot_widget_medium_rectangle = Metadata.get_ad_slot('medium_rectangle', 'default')
  end

  def load_ad_large_rectangle
    @slot_widget_large_rectangle = Metadata.get_ad_slot('large_rectangle', 'default')
  end

  def set_locale
    locale = params[:locale] || cookies[:locale] || I18n.default_locale
    I18n.locale = locale.to_s
    cookies[:locale] = locale unless (cookies[:locale] && cookies[:locale] == locale)
  end

  def set_iframe_status
    @enable_iframe_hack = false
    @force_enable_iframe = false
    @iframe_status = params[:iframe] || false
    headers["Newscloud-Origin"] = @iframe_status ? 'iframe' : 'web'
  end

  def enable_iframe_urls
    @force_enable_iframe = true
    headers["Newscloud-Origin"] = 'static'
  end

  def default_url_options(options={})
    format = options[:format] || request.format.to_sym
    unless ['html', 'json', 'js', 'xml', 'atom', 'rss'].include? format.to_s
      if request.xhr?
        format = 'json'
      else
        format = 'html'
      end
    end
    opts = {}
    unless true or options.key?(:locale) and options[:locale] == "false"
    	#opts[:locale] = I18n.locale
    end
    unless options.key?(:format) and options[:format] == "false"
      opts[:format] = format
    end
    # Disabled this and moved to IframeRewriter middleware due to fragment caching
    #opts[:iframe] = @iframe_status if @iframe_status and not options[:canvas] == true
    # TODO:: FIX:: Reenabled as a hack to update ajax json urls that aren't cached
    opts[:iframe] = @iframe_status if @iframe_status and (not options[:canvas] == true) and request.xhr?
    opts[:iframe] = @iframe_status if @iframe_status and @force_enable_iframe
    opts
  end

  def tag_cloud(item)
    @tags = item.tag_counts_on(:tags)
  end

  def current_user_profile
    return nil unless current_user.present?
    current_user.profile
  end

  def update_last_active
    return false unless current_user.present?

    last_active = current_user.last_active
    current_user.touch(:last_active)
    if current_facebook_user
      unless not Rails.env.development? and last_active and current_user.last_active < last_active + 1.hour
        redis_friends = $redis.smembers "#{current_user.cache_id}:friends"
        unless redis_friends.any? and last_active and current_user.last_active < last_active + 4.hours
          fb_friends = current_facebook_user.facebook_friend_ids
          $redis.set "#{current_facebook_user.cache_id}:friends_string", fb_friends.join(',')
          current_user.redis_update_friends fb_friends.join(',')
        end
        # Expire recent users
        Newscloud::Redcloud.expire_sets($redis.keys("#{User.model_deps_key}:*"))
      else
      end
    end
  end

  def check_authorized_param
    flash[:error] = "You must be logged in to do that!" if params[:unauthorized]
  end

  def find_polymorphic_item
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

  def expire_cache item
    WrapperSweeper.expire_item item
  end

  def canvas?
    iframe_facebook_request?
  end

  def iframe_facebook_request?
    !! @iframe_status
  end

  def after_facebook_login_url
    headers["Newscloud-Origin"] = 'no-rewrite'
    if canvas?
      link_user_accounts_users_path(:only_path => false, :iframe => 'iframe')
    else
      root_url
    end
  end

  def get_canvas_preference force = false
    # DISABLED:: canvas_app
    return false


    return false unless force
    preference = get_setting('default_site_preference').try(:value)
    return false unless preference
    return preference == 'iframe' ? true : false
  end

  def get_setting name, sub_type = nil
    Metadata::Setting.get(name, sub_type)
  end

  def get_setting_value name, sub_type = nil
    get_setting(name, sub_type).try(:value)
  end

  def setting_enabled? name, sub_type = nil
    !! get_setting_value(name, sub_type)
  end

  def get_ad_layout name, sub_type = nil
    Metadata::AdLayout.get name, sub_type
  end

  def set_custom_sidebar_widget
    cswidget = Metadata::CustomWidget.find_slot('sidebar', "#{self.controller_name}")
    @custom_sidebar_widget = (cswidget and cswidget.has_widget? ? cswidget.metadatable : nil)
  end

  def verify_request_format
    format = request.format.to_sym
    unless ['html', 'json', 'js', 'xml', 'atom', 'rss'].include? format.to_s
      if request.xhr?
      	request.format = 'json'
      else
      	request.format = 'html'
      end
    end
  end

  def set_ad_layout
    action = ( params['action'] == 'index' ? 'index' : 'item' )
    @ad_layout_info = get_ad_layout("#{params['controller']}_#{action}")
    if @ad_layout_info.present?
      @ad_layout = @ad_layout_info.layout
    elsif get_ad_layout("default").present?
      @ad_layout = get_ad_layout("default").layout
    else
      @ad_layout = nil
    end
    unless @ad_layout.nil?
      # load ad banners
      if @ad_layout.include? "Leader"
        @ad_leaderboard = Metadata.get_ad_slot('leaderboard', params['controller'])
      end
      if @ad_layout.include? "Banner"
        @ad_banner = Metadata.get_ad_slot('banner', params['controller'])
      end
      if ( @ad_layout.include? "Leader_B" or @ad_layout.include? "Banner_B" or @ad_layout.include? "Sky_A" )
        @ad_skyscraper = Metadata.get_ad_slot('skyscraper', params['controller'])
      end
      if ( @ad_layout.include? "Leader_C" or @ad_layout.include? "Banner_C" or @ad_layout.include? "Square_A" )
        @ad_small_square = Metadata.get_ad_slot('small_square', params['controller'])
      end
    end
  end

  # NOTE:: THIS SUCKS!!! DON'T USE THIS!!!
  # This is an annoying hack to redirect the top page url of a facebook canvas iframe app
  # Updated from: http://groups.google.com/group/facebooker/msg/f5790d4d45c80685
  def redirect_top location
    headers["Newscloud-Origin"] = 'no-rewrite'
    @redirect_url = location
    text = %{
      <html><head>
        <script type="text/javascript">
          window.top.location.href = <%= @redirect_url.to_json %>;
        </script>
        <noscript>
          <meta http-equiv="refresh" content="0;url=<%=h @redirect_url %>" />
          <meta http-equiv="window-target" content="_top" />
        </noscript>
      </head></html>
    }
    render :layout => false, :inline => text

  end

  def canvas_url
    "https://apps.facebook.com/#{APP_CONFIG["canvas_page_name"] || get_setting_value('site_title')}/"
  end

  def base_site_url
    APP_CONFIG['base_site_url']
  end

  def base_site_domain
    base_site_url.sub(%r{^https?://}, '')
  end

  def replace_url_with_canvas_url url
    url.sub %r{^#{base_site_url}/?(iframe/)?}, canvas_url
  end

  def replace_text_with_canvas_urls text
    text.gsub %r{#{base_site_url}/?(iframe/)?}, canvas_url
  end

  def replace_text_with_urls text, url
    txt = text.clone
    url ||= get_canvas_preference ? canvas_url : base_site_url
    url += '/' unless url =~ %r{/$}
    txt.gsub! %r{#{base_site_url}/?(iframe/)?}, url
    txt.gsub! %r{#{canvas_url}}, url
    txt
  end

  def access_denied
    store_location
    if current_user
      flash[:notice] = I18n.translate('sessions.invalid_permissions')
      redirect_to root_url
    else
      flash[:notice] = I18n.translate('sessions.access_denied')
      redirect_to new_session_path
    end
  end

  def detect_browser
    #raise request.headers["HTTP_USER_AGENT"].downcase.inspect
    "application"
  end

  def find_item_by_cache_id(cache_id)
    if cache_id =~ /^([a-zA-Z_]+):([0-9]+)$/
      begin
        $1.classify.constantize.send(:find_by_id, $2)
      # Should rescue only the necessary exceptions
      #rescue Exception => e
        #nil
      end
    else
      nil
    end
  end

  def set_current_meta_item item
    @current_meta_item = item
  end

  def get_current_meta_item
    @current_meta_item
  end

  def set_current_meta_klass klass
    @current_meta_klass = klass
  end

  def get_current_meta_klass
    @current_meta_klass
  end

  def klass_title klass
    I18n.translate("global.#{klass.name.tableize.downcase}.title".to_sym) || klass.name.tableize.downcase.titleize
  end

  def klass_description klass
    I18n.translate("global.#{klass.name.tableize.downcase}.description".to_sym) || klass.name.tableize.downcase.titleize
  end

  def page_title options = {}
    site_title = get_setting_value('site_title')
    if options[:item] and options[:item].respond_to?(:item_title)
      title = item.item_title
    elsif options[:klass] and options[:klass].respond_to?(:name)
      title = klass_description options[:klass]
    else
      title = site_title
    end
    # RAILS3 TODO
    # @template doesn't exist anymore
    # @template.text_page_title title
  end

end
