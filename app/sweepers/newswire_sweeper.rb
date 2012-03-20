class NewswireSweeper < ActionController::Caching::Sweeper

  def self.expire_newswires
    puts "Sweeping newswires"
    controller = ActionController::Base.new
    ['newswires_list', 'newest_newswires', 'newest_items'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "newswires_list_#{page}html"
    end
    NewscloudSweeper.expire_class(Newswire)

    Newscloud::Redcloud.expire_sets(Newscloud::Redcloud.redis.keys("#{Newswire.model_deps_key}:*"))

  end

end
