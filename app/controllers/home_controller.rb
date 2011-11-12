class HomeController < ApplicationController
  before_filter :set_current_tab

  def test_design
  end

  def preview_widgets
    @page = true
    @page = WidgetPage.find_root_by_page_name('home')
    if false and @page.present? and @page.children.present?
      @main = @page.children.first.children
    end
    @main = params[:widget_ids].split(',').map {|wid| Widget.find(wid) }
    @sidebar = []
  end

  def index
    if APP_CONFIG["use_view_objects"]
      render(:text => %{<div id="home_container">#{ViewTree.render(self)}</div>}.html_safe, :layout => 'application')
    else
      @page = "page_1_"
      @no_paginate = true
      @featured_items = FeaturedItem.find_root_by_item_name('featured_template')
      controller = self
      @page = WidgetPage.find_root_by_page_name('home')
      if @page.present? and @page.children.present?
        @main = @page.children.first.children
        @sidebar = @page.children.second.children
        @main.each {|w| controller.send(w.widget.load_functions) if w.widget.load_functions.present? }
        @sidebar.each {|w| controller.send(w.widget.load_functions) if w.widget.load_functions.present? }
      end
    end
  end

  def app_tab
    @no_paginate = true
    @featured_items = FeaturedItem.find_root_by_item_name('featured_template')
    controller = self
    @page = WidgetPage.find_root_by_page_name('home')
    if @page.present? and @page.children.present?
      @main = @page.children.first.children
      @main.each {|w| controller.send(w.widget.load_functions) if w.widget.load_functions.present?  }
    end
    render(:layout => 'app_tab', :template => 'home/beta_widgets_app_tab')
    return
  end

  def default_ads
    slot_name = params[:slot_name] || "default"
    render :partial => 'shared/ads/default_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def google_ads
    slot_name = params[:slot_name] || get_setting('google_adsense_slot_name').try(:value)
    render :partial => 'shared/ads/google_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def openx_ads
    slot_name = params[:slot_name] || get_setting('openx_slot_name').try(:value)
    render :partial => 'shared/ads/openx_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def helios_ads
    slot_name = params[:slot_name] || get_setting('helios_slot_name').try(:value)
    render :partial => 'shared/ads/helios_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def helios_alt2_ads
    slot_name = params[:slot_name] || get_setting('helios_slot_name').try(:value)
    render :partial => 'shared/ads/helios_alt2_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def helios_alt3_ads
    slot_name = params[:slot_name] || get_setting('helios_slot_name').try(:value)
    render :partial => 'shared/ads/helios_alt3_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def helios_alt4_ads
    slot_name = params[:slot_name] || get_setting('helios_slot_name').try(:value)
    render :partial => 'shared/ads/helios_alt4_ads', :locals => { :slot_name => slot_name },:layout => false
  end

  def about
  end

  def faq
  end

  def terms
  end

  def external_page
    render(:layout => 'external_page', :template => 'home/external_page_header')
  end

  def contact_us
    if request.post?
    	@message = Message.new(params[:message])
    	@message.user = current_user if current_user.present?

    	if @message.save
    		flash[:notice] = "Thank you for contacting us, your input is appreciated."
    		redirect_to root_path
    	else
    		flash[:error] = "There was an error while processing your request. Please try again."
    	end
    else
    	@message = Message.new
    	@message.email = current_user.email if current_user.present? and current_user.email.present?
    end
  end

  def test_widgets
    @no_paginate = true
    @featured_items = FeaturedItem.find_root_by_item_name('featured_template')
    controller = self
    @page = WidgetPage.find_root_by_page_name('home')
    @main = @page.children.first.children
    @sidebar = @page.children.second.children
    @main.each {|w| controller.send(w.widget.load_functions) if w.widget.load_functions.present? }
    @sidebar.each {|w| controller.send(w.widget.load_functions) if w.widget.load_functions.present? }
  end

  def render_widget
    @no_paginate = true
    controller = self
    @widget = Widget.find_by_id(params[:id])
    controller.send @widget.load_functions if @widget.load_functions.present?
    locals = @widget.locals.present? ? { @widget.locals.to_sym => instance_variable_get("@#{@widget.locals}") } : {}
    locals[:widget] = @widget

    render :partial => @widget.partial, :locals => locals and return
  end

  def robots
    render :partial => "shared/robots.txt", :layout => false and return
  end

  private
  def set_current_tab
    @current_tab = 'home'
  end

end
