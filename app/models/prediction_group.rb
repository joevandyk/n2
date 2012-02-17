class PredictionGroup < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable
  acts_as_tweetable

  belongs_to  :user
  has_many    :prediction_questions
  has_many :comments, :as => :commentable

  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true
  validates_presence_of :title, :user

  scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 7)} }
  scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 7)} }
  scope :approved, :conditions => { :is_approved => true }
  scope :currently_open, lambda { |*args| { :conditions => ["prediction_questions_count > 0 and status = 'open'" ] } }

  def to_s
    "Prediction Group: #{title}"
  end

  def approve!
    @prediction_group.update_attribute(:is_approved, true)
  end

  def next
    if PredictionGroup.count > 0
      PredictionGroup.approved.active.currently_open.find(:first, :conditions => ["id > ?", self.id ], :order => "id asc")
    else
      nil
    end
  end

  def previous
    if PredictionGroup.count > 0
      PredictionGroup.approved.active.currently_open.find(:first, :conditions => ["id < ?", self.id ], :order => "id desc")
    else
      nil
    end
  end

  def expire
    self.class.sweeper.expire_prediction_group_all self
  end

  def self.sweeper
    PredictionSweeper
  end

  def voices
    # users who guessed on questions for this group
    self.prediction_questions.prediction_guesses.find(:all, :include => :user, :group => :user_id).map(&:user)
  end

  def recipient_voices
    users = self.voices
    users << self.user
    users.concat self.votes.map(&:voter)
    users.uniq
  end

end
