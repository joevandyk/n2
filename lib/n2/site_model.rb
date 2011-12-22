class N2::SiteModel < ActiveRecord::Base
  include N2::CurrentSite

  def self.abstract_class?; true; end
end
