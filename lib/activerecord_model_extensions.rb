require 'active_record'

module Newscloud
  module ActiverecordModelExtensions

    def self.included(base)
      base.send :extend, ClassMethods

      base.send :include, InstanceMethods
    end

    module ClassMethods

      def item_klasses
        ['article', 'audio', 'content', 'event', 'gallery', 'idea', 'question', 'resource']
      end

      def rankable_classes
        #["Image", "PredictionGuess", "Question",  "Idea", "Forum", "Event", "PredictionGroup", "IdeaBoard", "Video", "Url", "Gallery", "Resource", "Comment", "Audio", "Classified", "GalleryItem", "PredictionQuestion", "Feed", "Card", "Content", "ResourceSection", "Article", "Topic", "Answer"].map(&:constantize)
        ["PredictionGuess", "Question",  "Idea", "Event", "PredictionGroup", "Gallery", "Resource", "Classified", "PredictionQuestion", "Content", "Article", "Topic", "Answer"].map(&:constantize)
      end

      def top_article_items limit = 100
        table = self.name.tableize
        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        # TODO we can do this better in pg, do it later
        return self.limit(limit)
        # self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked is false AND article_id is NOT NULL) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
      end

      def top_story_items(limit = 100, within_last_week = false)
        # HACK ALERT
        # This will return an ordered set of results based on number of votes and time since posting
        # RAILS3 TODO
        return self.order('created_at desc').limit(limit)
        table = self.name.tableize
        # TODO we can do this better in pg, do it later
        return self.limit(limit)

        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        if !within_last_week
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP('#{now}') - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked is false AND article_id is NULL) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        else
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP('#{now}') - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked is false AND article_id is NULL AND created_at > date_sub("#{now}", INTERVAL 7 DAY) ) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        end
      end

      def top_items(limit = 100, within_last_week = false)
        # TODO:: this needs work
        return self.order("created_at desc").limit(limit) unless self.columns.select {|col| col.name == 'votes_tally'}

        table = self.name.tableize
        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        # HACK ALERT
        # This will return an ordered set of results based on number of votes and time since posting
        # RAILS3 TODO
        return self.order('created_at desc').limit(limit)
=begin
        if self.columns.select {|col| col.name == 'is_blocked'}
          if !within_last_week
            self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE is_blocked = 0 ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
          else
            self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE is_blocked = 0 AND created_at > date_sub("#{now}", INTERVAL 7 DAY) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
          end
        else
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        end
        #self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("2010-03-23 14:20:24") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
=end
      end

      def refineable?() false end
      def tweetable?() false end

      def expire_all
        nil
      end

      def sweeper
        nil
      end

      def model_index_name
        self.name.tableize.titleize
      end

      def model_index_url_name
        "#{self.name.tableize.gsub(/\//, '_')}_url"
      end

      def model_new_url_name
        "new_#{self.name.underscore.gsub(/\//, '_')}_url"
      end

      def view_object_random_item
        if (c = count) != 0
          find(:all, :offset => rand(c), :limit => 1)
        else
          return []
        end
      end

      def model_deps_key
        "#{self.name.downcase}:view_object_namespace_deps"
      end

    end

    module InstanceMethods

      # Misc continuity methods for working with mixins
      def wall_postable?() false end
      def moderatable?() false end
      def refineable?() false end
      def relatable?() false end
      def featured_item?() false end
      def media_item?() false end
      def galleryable?() false end
      def image_item?() false end
      def video_item?() false end
      def audio_item?() false end
      def downvoteable?() false end
      def scorable?() false end
      def tweetable?() false end

      # model unique identifier
      def muid
        "#{self.class.name.underscore}_#{self.id}"
      end

      # model unique identifier for redis cache keys
      def cache_id
        "#{self.class.name.underscore}:#{self.id}"
      end

      def model_deps_key
        "#{self.cache_id}:view_object_deps"
      end

      def item_link
        self
      end

      def wall_caption
        return ''
      end

      def locale_model_name
        self.class.name.tableize
      end

      def model_index_name
        self.class.model_name.pluralize
      end

      def model_index_url_name
        self.class.model_index_url_name
      end

      def model_new_url_name
        self.class.model_new_url_name
      end

      def item_title
        [:title, :name, :question].each do |method|
          return self.send(method) if self.respond_to?(method) and self.send(method).present?
        end
        "#{self.class.name.titleize} ##{self.id}"
      end

      def item_score
        ItemScore.get_score(self)
      end

      def item_tally
        ItemAction.tally_for_item(self)
      end

      def item_description
        [:description, :caption, :blurb, :details, :details].each do |method|
          return self.send(method) if self.respond_to?(method) and self.send(method).present?
        end
        "#{self.class.name.titleize} ##{self.id}"
      end

      def item_user
        [:user, :author].each do |method|
          return self.send(method) if self.respond_to?(method) and self.send(method).present?
        end
        nil
      end

      # Breadcrumb parents method
      # Overwrite as [self.story.crumb_items]
      def crumb_parents
        []
      end

      def crumb_items
        [self, self.crumb_parents].flatten
      end

      def crumb_text
        self.item_title
      end

      def crumb_link
        self
      end

      def expire
        nil
      end

      def action_links
        links = []
        if self.respond_to? :votes_tally
          #links << lambda {|klass| vote_link(klass) }
          #links << lambda {|klass| tally_link(klass) }
        end
        if self.respond_to? :comments
          #links << lambda {|klass| comment_link(klass) }
        end
        links
      end

    end

  end
end
