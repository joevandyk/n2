class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true

  has_many :site_groups
  belongs_to :parent_site, :class_name => "Site", :foreign_key => 'parent_id'
  has_many   :all_sites,   :class_name => "Site", :through => :site_group
  #has_many   :other_sites, :class_name => "Site"
  #has_many   :child_sites, :class_name => "Site"

  def self.current
    @current_site || Site.default
  end

  def self.current_domain= domain
    @current_site = Site.where('lower(domain) = ?', domain.downcase).first
  end

  # There should always be a default site (right?)
  def self.default
    Site.order('id').first
  end
end
