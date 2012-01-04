class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true

  belongs_to :site_group

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
