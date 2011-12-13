class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true
end
