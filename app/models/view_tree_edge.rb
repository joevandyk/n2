class ViewTreeEdge < ActiveRecord::Base
  include N2::CurrentSite
  belongs_to :parent, :class_name => "ViewObject"
  belongs_to :child, :class_name => "ViewObject"
end
