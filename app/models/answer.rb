class Answer < ActiveRecord::Base
  include N2::CurrentSite

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable

  belongs_to  :user
  belongs_to  :question, :counter_cache => true, :touch => true
  has_many    :comments, :as => :commentable

  validates_presence_of :answer

  scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }
  scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  scope :featured, lambda { |*args| { :conditions => ["is_featured is true "],:order => ["created_at desc"], :limit => (args.first || 3)} }

  def voices
    Answer.find(:all,
                :include => :user,
                :conditions => {:question_id => self.question_id}).
                map(&:user).uniq
  end

  def recipient_voices
    users = self.voices
    users << self.question.user
    users.delete self.user
    users.uniq
  end

  def self.get_top
    self.tally({
      :at_least => 1,
      :limit    => 10,
      :order    => "vote_count desc"
    })
  end

  def item_title
    "Answer to: #{self.question.item_title}"
  end

  def item_description
    answer
  end

  def item_link
    question.item_link
  end

  def expire
    self.class.sweeper.expire_answer_all self
  end

  def self.expire_all
    self.sweeper.expire_answer_all self.new
  end

  def self.sweeper
    QandaSweeper
  end

end
