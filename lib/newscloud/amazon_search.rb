require 'amazon/ecs'

module Newscloud
  module AmazonSearch

    def self.load_config
      Rails.logger.debug "Loading amazon config"
      puts "Loading amazon config"
      aws_access_key_id = Metadata::Setting.get 'aws_access_key_id', 'amazon'
      aws_secret_key = Metadata::Setting.get 'aws_secret_key', 'amazon'
      associate_code = Metadata::Setting.get("associate_code", "amazon")
      raise "Amazon keys not configured" unless aws_access_key_id and aws_secret_key and associate_code
      Amazon::Ecs.options = {:AWS_access_key_id => aws_access_key_id.value, :AWS_secret_key => aws_secret_key.value, :response_group => "Large", :associate_tag => associate_code.value}
      @config = Amazon::Ecs.options
    end

    def self.item_search(keywords, category = 'Books')
      self.load_config unless @config
      res = Amazon::Ecs.item_search(keywords, :search_index => category)
      items = []
      res.items.each do |search_item|
        item = {}
        item[:title] = search_item.get("ItemAttributes/Title")
        item[:asin] = search_item.get("ASIN")
        item[:detail_page_url] = search_item.get("DetailPageURL")
        item[:url] = search_item.get("DetailPageURL")
        #item[:url] = "http://amazon.com/dp/#{item[:asin]}"
        thumbimage = search_item.get_hash("SmallImage")
        fullimage = search_item.get_hash("LargeImage")
        item[:thumb_image_url] = thumbimage ? thumbimage["URL"] : nil
        item[:full_image_url] = fullimage ? fullimage["URL"] : nil

        items.push item
      end
      items
    end

    def self.categories
      @categories ||= ["Apparel", "Baby", "Beauty", "Blended", "Books", "Classical", "Digital Music", "DVD", "Electronics", "Gourmet Food", "Health Personal Care", "Jewelry", "Kitchen", "Magazines", "Merchants", "Miscellaneous", "Music", "Musical Instruments", "Music Tracks", "Office Products", "Outdoor Living", "PC Hardware", "Photo", "Restaurants", "Software", "Sporting Goods", "Tools", "Toys", "VHS", "Video", "Video Games", "Wireless", "Wireless Accessories"]
    end

    def self.categories_options
      self.categories.map {|c| [c,c] }
    end

    def self.default_category
      "Books"
    end

    class AmazonItem

      def initialize asin
        @asin = asin
      end

      def url
        "http://amazon.com/dp/#{@asin}"
      end
    end

  end
end
