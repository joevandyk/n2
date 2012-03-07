class Resource < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_tweetable
  acts_as_wall_postable
  acts_as_relatable

  scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  scope :featured, lambda { |*args| { :conditions => ["is_featured is true"],:order => ["created_at desc"], :limit => (args.first || 3)} }
  scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }

  belongs_to :user
  belongs_to :resource_section
  has_many :comments, :as => :commentable
  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :site_id
  validates_presence_of :url
  validates_uniqueness_of :url, :scope => :site_id
  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL"
  validates_presence_of :resource_section
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."

  def self.per_page; 20; end

  def expire
    self.class.sweeper.expire_resource_all self
  end

  def self.expire_all
    self.sweeper.expire_resource_all self.new
  end

  def self.sweeper
    ResourceSweeper
  end


end
