class FeedsWorker
  @queue = :feeds

  def self.perform(site_id=nil, feed_id = nil)
    if feed_id
      Site.current_id = site_id
      feed = Feed.enabled.active.find_by_id(feed_id)
      N2::FeedParser.update_feed Feed.active.find(feed_id) if feed
    else
      Site.run_on_each {
      N2::FeedParser.update_feeds
      }
    end
  end
end
