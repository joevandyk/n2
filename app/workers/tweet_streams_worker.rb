class TweetStreamsWorker
  @queue = :tweet_streams

  def self.perform(site_id, tweet_stream_id = nil)
    Site.current_id = site_id

    tweet_streams = []
    if tweet_stream_id
      tweet_streams.push TweetStream.active.find(tweet_stream_id)
    else
      tweet_streams = TweetStream.active.all
    end

    new_tweets = tweet_streams.map(&:fetch_new_tweets!)

    new_tweets.flatten.each do |tweet|
      tweet.build_related
    end
  end
end
