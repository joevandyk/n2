class TweetedItem < ActiveRecord::Base
  include N2::CurrentSite
  belongs_to :item,    :polymorphic => true
end
