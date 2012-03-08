class TwitterWorker
  @queue = :twitter

  def self.perform(site_id, klass, id)
    Site.current_id = site_id

    item = klass.constantize.find(id)
    return false unless item

    tweeter = Newscloud::Tweeter.new
    tweeter.tweet_item item
  end
end
