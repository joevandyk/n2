class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true

  def self.current
    @current_site
  end

  def self.current_domain= domain
    @current_site = Site.where('lower(domain) = ?', domain.downcase).first
  end
end
