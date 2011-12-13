class Site < ActiveRecord::Base
  validates :site, :name, :presence => true
end
