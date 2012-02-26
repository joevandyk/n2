class SiteGroup < ActiveRecord::Base
  has_and_belongs_to_many :sites
  belongs_to :primary_site, :class_name => 'Site'

  validates :name, :primary_site, :presence => true
end
