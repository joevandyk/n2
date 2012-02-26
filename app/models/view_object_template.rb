class ViewObjectTemplate < ActiveRecord::Base
  include N2::CurrentSite
  has_many :view_objects
end
