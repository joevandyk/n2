class ExternalAuthKey < ActiveRecord::Base
  include N2::CurrentSite

  # Given type of 'facebook', loads the keys/secrets for that site's fb
  def self.load type
    where(:external_site_type => type).first
  end
end
