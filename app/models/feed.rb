class Feed < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_moderatable
  acts_as_taggable_on :tags, :topics

  has_many :newswires
  belongs_to :user

  validates_presence_of :title
  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
  validates_format_of :rss, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false

  scope :roll, lambda { |*args| { :conditions => ["feedType != ? AND feedType != ?", 'images', 'bookmarks' ], :order => ["last_fetched_at desc"], :limit => (args.first || 7)} }
  scope :active, lambda { |*args| { :conditions => ["deleted_at is null and is_blocked is false and enabled is true" ] } }
  scope :enabled, :conditions => { :enabled => true }
  scope :disabled, :conditions => { :enabled => false }

  def to_s
    self.title
  end

  def full_html?
    self.loadOptions == 'full_html'
  end

  def self.add_default_feed! rss_url, opts = {}
    opts[:rss]      =   rss_url
    opts[:enabled]  =   false
    opts[:url]      ||= rss_url
    opts[:title]    ||= rss_url
    opts[:tag_list] = opts.delete(:topic)

    f = Feed.create(opts)
  end

  def self.default_feed_topics
    Feed.tag_counts.inject({}) do |list, tag|
      feeds = Feed.disabled.tagged_with(tag[:name])
      list[tag[:name]] = feeds if feeds.any?

      list
    end
  end

  def async_update_feed
    Resque.enqueue(FeedsWorker, self.site_id, self.id)
  end

  def self.async_update_feeds
    Resque.enqueue(FeedsWorker, self.site_id)
  end

end
