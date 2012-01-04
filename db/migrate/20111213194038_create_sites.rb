class CreateSites < ActiveRecord::Migration
  def change

    # Create sites table
    create_table :sites do |t|
      t.string :name,   :null => false
      t.string :domain, :null => false
    end

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

      # Create id and site_id indexes on each table
      execute "create index on #{ table } using btree(id); create index on #{ table } using btree(site_id);"
    end

    # Create site group table .
    # Each site belongs to a group of other sites.
    # Each site group has a 'primary' site.
    execute "
create table site_groups (
  id serial primary key,
  name text not null,
  primary_site_id integer not null references sites(id)
);
   "

  # The join table of sites to site_groups
  execute "
  create table sites_site_groups (
    site_id integer not null references sites(id),
    site_group_id integer not null references site_groups(id),
    primary key (site_id, site_group_id)
  );
  create index on sites_site_groups using btree(site_group_id);
  "

  # Each site can be in a maximum of one group.
  execute "create unique index on sites_site_groups using btree(site_id);"

  SiteGroup.create! :sites => Site.all, :name => "Default Site Group", :primary_site => Site.first

    raise 'stop early'
  end
end
