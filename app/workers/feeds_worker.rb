class FeedsWorker
  @queue = :feeds

  def self.perform(site_id, feed_id = nil)
    Site.current_id = site_id
    if feed_id
      feed = Feed.enabled.active.find_by_id(feed_id)
      N2::FeedParser.update_feed Feed.active.find(feed_id) if feed
    else
      N2::FeedParser.update_feeds
    end
  end
end
