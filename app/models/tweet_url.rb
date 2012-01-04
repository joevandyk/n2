class TweetUrl < ActiveRecord::Base
  include N2::CurrentSite
  belongs_to :tweet
  belongs_to :url
end
