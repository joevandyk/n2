class Site < ActiveRecord::Base
  include N2::CurrentSite
  validates :domain, :name, :presence => true

  def self.current
    @current_site
  end

  def self.current_domain= domain
    @current_site = Site.where('lower(domain) = ?', domain.downcase).first
  end
end
