class Site < ActiveRecord::Base
  validates :domain, :name, :presence => true
  after_create :load_default_data
  belongs_to :site_group

  def master?
    site_group.primary_site_id == self.id
  end

  def parent_site
    site_group.primary_site
  end

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

  # Temporarily use the passed in site as the current site
  def self.use_as_current site, &block
    original_site = Site.current
    Site.current_domain = site.domain
    block.call
    Site.current_domain = original_site.domain
  end

  private

  def load_default_data
    Site.use_as_current(self) do
      load Rails.root.join('db/seeds.rb')
    end
  end
end
