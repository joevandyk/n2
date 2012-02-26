class SmtpSetting < ActiveRecord::Base
  include N2::CurrentSite
  validates :address, :port, :domain, :authentication, :username, :password, :presence => true
  self.primary_key = :site_id
end
