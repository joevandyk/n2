class WidgetsController < ApplicationController

  before_filter :get_parameters
  before_filter :set_canvas_preference
  
  def get_parameters
    @count = Integer(params[:count] ? params[:count] : 5)
    @sort = (params[:sort] ? params[:sort] : "newest")
    @filter = (params[:filter] ? params[:filter] : false)
    @scrollable = (params[:scrollable] ? true : false)
    @fan = (params[:fan] ? true : false)
    @hide_titlebar = (params[:hide_titlebar] ? true : false)
  end
  
  def add_bookmark
    render :partial => 'shared/sidebar/add_bookmark' , :layout => 'widgets'
  end
  
  def fan_application
    render :partial => 'shared/sidebar/fan_application' , :layout => 'widgets'
  end
  
  def activities
    @title = t('widgets.activities_title', :site_title => get_setting('site_title').value)
    @items = ItemAction.top_items :limit => @count, :minimum => @count
  end
  
  def user_articles
    @title_possessive = (params[:title_possessive] ? true : false)
    @user_cached_slug = (params[:user] ? params[:user] : nil)
    @user = User.active.find_by_cached_slug(@user_cached_slug)
    #redirect_to articles unless @user
    @article_list = Content.active.find(:all, :joins => "INNER JOIN articles on contents.article_id = articles.id", :conditions => ["contents.is_blocked =0 and article_id IS NOT NULL and is_draft = 0 and author_id = ?", @user.id], :limit => @count)
    if @title_possessive
      @title = t('widgets.my_articles_title', :site_title => get_setting('site_title').value )
    else
      @title = t('widgets.articles_yours_title', :name => @user.name )
    end
    render :template => 'widgets/articles', :layout => 'widgets'
  end

  def blog_roll
    @users = Article.active.find(:all, :joins => "INNER JOIN user_profiles on user_profiles.user_id = author_id", :select => "count(author_id) as author_article_count, author_id,bio", :group => "author_id", :order => "author_article_count desc", :limit => @count ) 
    @title = t('widgets.blogger_profiles_title', :site_title => get_setting('site_title').value)
    render :partial => 'shared/sidebar/blog_roll', :layout => 'widgets'
  end

  def blogger_profiles
    @users = Article.active.find(:all, :joins => "INNER JOIN user_profiles on user_profiles.user_id = author_id", :select => "count(author_id) as author_article_count, author_id,bio", :group => "author_id", :order => "author_article_count desc", :limit => @count ) 
    @title = t('widgets.blogger_profiles_title', :site_title => get_setting('site_title').value)
  end
  
  def articles    
    unless @filter
      case @sort      
        when "newest"
          @article_list = Content.active.articles.published.newest @count
          @title = t('widgets.articles_newest_title', :site_title => get_setting('site_title').value)
        when "top"
          @article_list = Content.active.articles.published.top @count
          @title = t('widgets.articles_top_title', :site_title => get_setting('site_title').value)
      end
    else
      @article_list = Content.active.articles.published.featured @count
      @title = t('widgets.articles_featured_title', :site_title => get_setting('site_title').value)      
    end
  end

  def classifieds
    @title = t("widgets.classifieds_newest_title", :site_title => get_setting_value('site_title'))
    @classifieds = Classified.for_user(current_user).paginate :page => 1, :per_page => @count
  end
  
  def stories
    unless @filter
      case @sort
        when "newest"
          @contents = Content.active.newest @count
          @title = t('widgets.contents_newest_title', :site_title => get_setting('site_title').value)
        when "top"
          @contents = Content.active.top @count
          @title = t('widgets.contents_top_title', :site_title => get_setting('site_title').value)
      end
    else
      @contents = Content.active.featured @count
      @title = t('widgets.contents_featured_title', :site_title => get_setting('site_title').value)      
    end
  end

  def questions
    unless @filter
      case @sort
        when "newest"
          @questions = Question.active.newest @count
          @title = t('widgets.questions_newest_title', :site_title => get_setting('site_title').value)
        when "top"
          @questions = Question.active.top @count
          @title = t('widgets.questions_top_title', :site_title => get_setting('site_title').value)
      end
    else
      @questions = Question.active.featured @count
      @title = t('widgets.questions_featured_title', :site_title => get_setting('site_title').value)      
    end
  end

  def newswires
    @newswires = Newswire.active.unpublished.newest @count
    @title = t('widgets.newswires_newest_title', :site_title => get_setting('site_title').value)
  end

  def set_canvas_preference
    @canvas_preference = get_canvas_preference true
  end
  
end
