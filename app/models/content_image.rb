class ContentImage < ActiveRecord::Base
  include N2::CurrentSite
  belongs_to :content

  def to_s
    self.url
  end
end
