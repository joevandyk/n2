class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name,   :null => false
      t.string :domain, :null => false
      t.timestamps
    end

    site = Site.create! :name => "A Name", :domain => "localhost"

    %w( announcements
        answers
        articles
        audios
        authentications
        cards
        categories
        categorizations
        chirps
        classifieds
        comments
        consumer_tokens
        content_images
        contents
        dashboard_messages
        events
        fbSessions
        featured_items
        feeds
        flags
        forums
        galleries
        gallery_items
        gos
        idea_boards
        ideas
        images
        item_actions
        item_tweets
        locales
        messages
        metadatas
        newswires
        pfeed_deliveries
        pfeed_items
        prediction_groups
        prediction_guesses
        prediction_results
        prediction_scores
        questions
        related_items
        resource_sections
        roles
        roles_users
        scores
        sent_cards
        sessions
        slugs
        sources
        taggings
        tags
        topics
        translations
        tweet_accounts
        tweet_streams
        tweet_urls
        tweeted_items
        tweets
        urls
        user_profiles
        users
        videos
        view_object_templates
        view_objects
        view_tree_edges
        votes
        widget_pages).each do |table|
          add_column table, :site_id, :integer
        end
  end
end
