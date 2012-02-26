class Chirp < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_moderatable

  belongs_to :chirper, :class_name => "User", :foreign_key => :user_id
  belongs_to :recipient, :class_name => "User", :foreign_key => :recipient_id
  validates_presence_of :recipient, :message, :chirper
end
