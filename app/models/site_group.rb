class SiteGroup < ActiveRecord::Base
  belongs_to :parent
  has_many :sites
end
