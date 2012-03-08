require 'rubygems'
require 'sequel'
require 'pg'
require 'json'
STDOUT.sync = true

LIVE_DB = Sequel.connect(ENV['LIVE_DB'])
DB = Sequel.connect(ENV['DB'])

def execute query
  DB.run query
end

execute "
create table if not exists sites (
  id serial primary key,
  name text not null unique,
  domain text not null unique,
  timezone text not null default 'UTC'
)"

execute "drop table if exists fbSessions cascade"
execute "drop table if exists active_admin_comments cascade"
execute "drop sequence if exists active_admin_comments_id_seq cascade"
execute "drop sequence if exists fbsessions_id_seq cascade"

# Create the first default site, all the existing data in this db will belong to this site
site_id = (LIVE_DB[:sites].max(:id) || 0) + 1
DB[:sites].insert(:name => ENV['NAME'], :domain => ENV['DOMAIN'], :id => site_id)
LIVE_DB.run "select setval('sites_id_seq', #{site_id + 1}, false);"

config = JSON.parse(ENV['CONFIG'])

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
        item_scores
        item_tweets
        locales
        menu_items
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
        resources
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
  begin
    puts "Migrating table #{ table }..."
    # Drop primary key constraint, ignores this table if no primary key exists.
    execute "alter table #{ table } drop constraint #{ table }_pkey;"

    #  Add site_id to each table, make (id, site_id) a primary key, add indexes
    execute "alter table #{ table } add column site_id integer references sites(id)"

    execute "update #{ table } set site_id = #{ site_id }"

    # Add (site_id, id) primary key
    execute "alter table #{ table } alter column site_id set not null, add primary key (id, site_id);"

    # Create id and site_id indexes on each table
    execute "create index on #{ table } using btree(id); create index on #{ table } using btree(site_id);"
  rescue
    puts $!
  end
end

execute "
CREATE TABLE external_auth_keys (
    site_id integer NOT NULL references sites(id),
    external_site_type text NOT NULL,
    key text NOT NULL,
    secret text NOT NULL,
    CONSTRAINT external_auth_keys_length_check CHECK (((length(key) > 1) AND (length(secret) > 1))),
    CONSTRAINT external_auth_keys_site_type CHECK (external_site_type in ('facebook', 'twitter')),
    primary key (site_id, external_site_type)
);

CREATE TABLE smtp_settings (
    site_id integer primary key,
    address text NOT NULL,
    port integer NOT NULL,
    domain text NOT NULL,
    authentication text NOT NULL,
    user_name text NOT NULL,
    password text NOT NULL,
    enable_starttls_auto boolean DEFAULT false NOT NULL
);
"


site_config = config["sites"][ENV['NAME']]

if o = site_config["smtp"]
  o.merge!(:site_id => site_id)
  DB[:smtp_settings].insert(o)
end

if o = site_config["auth"]["facebook"]
  o.merge!(:site_id => site_id, :external_site_type => 'facebook')
  DB[:external_auth_keys].insert(o)
end

if o = site_config["auth"]["twitter"]
  o.merge!(:site_id => site_id, :external_site_type => 'twitter')
  DB[:external_auth_keys].insert(o)
end
