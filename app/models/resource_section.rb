class ResourceSection < ActiveRecord::Base
   acts_as_featured_item
   acts_as_moderatable
   acts_as_taggable_on :tags

  scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  scope :alpha, lambda { |*args| { :order => ["name asc"], :limit => (args.first || 10)} }

  has_many :resources

  has_friendly_id :name, :use_slug => true
  validates_presence_of :name, :section, :description

  def to_s
    "Resource Section: #{name}"
  end

end
