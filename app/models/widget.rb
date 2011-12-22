class Widget < ActiveRecord::Base
  include N2::CurrentSite

  has_many :metadatas, :as => :metadatable

  scope :main, { :conditions => ["content_type ='main_content'"] }
  scope :sidebar, { :conditions => ["content_type ='sidebar_content'"] }

  def metadata
    self.metadatas.first
  end

  def css_class
    ''
  end
end
