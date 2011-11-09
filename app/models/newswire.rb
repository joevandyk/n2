class Newswire < ActiveRecord::Base
  acts_as_moderatable


  belongs_to :feed, :counter_cache => true, :touch => true
  belongs_to :user
  has_one :content

  scope :unpublished, { :conditions => ["published = ?", false] }
  scope :newest, lambda { |*args| {  :conditions => ["created_at <= ?", Time.zone.now ], :order => ["created_at desc"], :limit => (args.first || 7)} }

  def quick_post user_id = nil, override_image = false
    user_id ||= self.feed.user_id
    @user = User.find_by_id(user_id) || User.admins.first
    return false unless @user

    caption = CGI.unescapeHTML self.caption
    begin
      caption = ActionController::Base.helpers.strip_tags(caption)
    rescue
      begin
        caption = HTML::FullSanitizer.new.sanitize(caption)
      rescue
      end
    end
    caption = self.title unless caption.present?
    story_type = self.feed.full_html? ? 'full_html' : 'story'
    @content = Content.new({
    	:title      => self.title,
    	:caption    => caption,
    	:url        => self.url,
    	#:source     => self.feed.title,
    	:user_id    => user_id,
    	:newswire   => self,
    	:story_type => story_type
    })

    if self.imageUrl.present?
    	@content.images.build({ :remote_image_url => self.imageUrl})
    	@content.images.first.override_image = true if override_image
    else
    	begin
        page = Parse::Page.parse_page self.url
        unless page[:images_sized].empty?
          @content.images.build({ :remote_image_url => page[:images_sized].first[:url] })
        end
      rescue
        Rails.logger.info("PARSE PAGE ERROR: failed to parse page: #{self.url}")
      end
    end

    begin
      if @user.contents << @content
        ItemAction.gen_user_posted_item!(@user, @content)
      	set_published
      	NewswireSweeper.expire_newswires
      	@content.expire
        if Metadata::Setting.find_setting('tweet_all_moderator_items').try(:value)
          if @content.user.is_moderator?
            @content.tweet
          end
        end
      	return true
      else
      	errors.add(:content, @content.errors.full_messages.join('. '))
      	return false
      end
    rescue
      	errors.add(:content, "Blew up")
      return false
    end
  end

  def set_published
    self.update_attribute(:published, true)
  end

  def expire
    self.class.sweeper.expire_newswires
  end

  def self.expire_all
    self.sweeper.expire_newswires
  end

  def self.sweeper
    NewswireSweeper
  end

  def action_links
    links = []
    links << lambda {|klass| newswire_via(klass) }
    links << lambda {|klass| publish_newswire(klass) }
    links << lambda {|klass| read_newswire(klass) }
    links
  end

  def item_link
    url
  end

end
