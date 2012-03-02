class FixSequenceValues < ActiveRecord::Migration
  def up
    tables =
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
        prediction_questions
        prediction_scores
        questions
        related_items
        resource_sections
        roles
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
        widget_pages
        widgets)


    tables.each do |table|
      execute "select setval('#{table}_id_seq', (select max(id) from #{table}))"
    end
  end

  def down
  end
end
