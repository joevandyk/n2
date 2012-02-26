require 'rubygems'
require 'sequel'
require 'pg'
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
        menu_items
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
  create table site_groups_sites (
    site_id integer not null references sites(id),
    site_group_id integer not null references site_groups(id),
    primary key (site_id, site_group_id)
  );
  create index on site_groups_sites using btree(site_group_id);
"

# Each site can be in a maximum of one group.
execute "create unique index on site_groups_sites using btree(site_id);"




execute "
create table if not exists external_auth_sites (
  name text primary key
);

-- should only run once
do $f$ begin
  if ((select count(*) from external_auth_sites) = 0) then
    insert into external_auth_sites values ('facebook'), ('twitter');
  end if;
end $f$;

create table if not exists external_auth_keys (
  site_id integer not null references sites(id),
  external_site_type text not null references external_auth_sites(name),
  key text not null,
  secret text not null,
  unique(site_id, external_site_type),
  check (length(key) > 1 and length(secret) > 1)
);"
