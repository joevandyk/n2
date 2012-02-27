class UserProfile < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_moderatable

  belongs_to :user

  def expire
    self.class.sweeper.expire_user_all self.user
  end

  def self.expire_all
    self.sweeper.expire_user_all User.new
  end

  def self.sweeper
    UserSweeper
  end
end
