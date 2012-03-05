class ExternalAuthKey < ActiveRecord::Base
  include N2::CurrentSite
  set_primary_keys :external_site_type, :site_id

  SITES = %w( twitter facebook)

  validates :external_site_type, :inclusion => SITES

  # Given type of 'facebook', loads the keys/secrets for that site's fb
  def self.load type
    where(:external_site_type => type).first
  end
end
