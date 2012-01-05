class CreateSites < ActiveRecord::Migration
  def change

    execute "
create table sites (
  id serial primary key,
  name text not null,
  domain text not null,
  parent_id integer references sites(id),
  check (length(name) > 0),
  check (length(domain) > 0)
);

create index on sites using btree(domain);
create index on sites using btree(parent_id);
    "

    # Create the first default site, all the existing data in this db will belong to this site
    site = Site.create! :name => "A Name", :domain => "localhost"

    # List of the tables we care about.
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
        widgets
      )

    tables.each do |table|
      # Drop primary key constraint, ignores this table if no primary key exists.
      execute "alter table #{ table } drop constraint #{ table }_pkey;"

      #  Add site_id to each table, make (id, site_id) a primary key, add indexes
      execute "alter table #{ table } add column site_id integer references sites(id)"

      # Update the site_id of each table to the first site's id
      execute "update #{ table } set site_id = #{ Site.first.id };"

      # site_id column shouldn't be null anymore
      execute "alter table #{ table } alter column site_id set not null;"

      # Add (site_id, id) primary key
      execute "alter table #{ table } add primary key (id, site_id);"

      # Create id and site_id indexes on each table
      execute "create index on #{ table } using btree(id); create index on #{ table } using btree(site_id);"
    end

    # Create site group view
    #execute "
#create view site_groups as (
  #select parent_id
#);
    #"

    Site.create! :parent_site => Site.first, :name => "Other Site in Group", :domain => "othersiteingroup.com"
    Site.create! :name => "A Parent Site", :domain => "parent-site.com"

  end
end
