class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true

  belongs_to :site_group

  def self.current
    @current_site || default
  end

  def self.current_id= site_id
    @current_site = Site.find(site_id) || default
  end

  def self.current_domain= domain
    @current_site = Site.where('lower(domain) = ?', domain.downcase).first || default
  end

  # There should always be a default site (right?)
  def self.default
    Site.order('id').first
  end

  def self.run_on_each &block
    Site.all.each do |site|
      Site.current_id = site.id
      block.call
    end
  end
end
