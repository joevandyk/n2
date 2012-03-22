begin;

create unique index on sites using btree(lower(name));
create unique index on sites using btree(lower(domain));

alter table site_groups 
  drop column primary_site_id,
  add column primary_site_id integer references sites deferrable initially deferred,
  add unique (primary_site_id)
  ;

-- Lets formtastic know this should be a shorter string
alter table external_auth_keys
  alter column external_site_type type varchar,
  alter column key type varchar,
  alter column secret type varchar;

-- Add an email column to sites
alter table sites
  add column email varchar;

-- Update the email column with the first admin user from each site
with ids as (
  select min(id) id, site_id
  from users
  where is_admin is true and length(email) > 0
  group by site_id
),
emails as (
  select email, site_id
  from users
  inner join ids using (id, site_id)
)
update sites 
  set email = emails.email
  from emails
  where sites.id = emails.site_id;

-- Update email with a default value
update sites set email = 'user@email.com' where email is null;

-- Set the not null constraint on sites.email
alter table sites alter column email set not null;

-- Don't need this.
drop table site_groups_sites;

-- Add a site_group_id column to sites. Sites will belong to only one group
-- at a time.
alter table sites add column site_group_id integer references site_groups(id) deferrable;

-- Populate the site groups table.
with ids as (
  insert into site_groups (name, primary_site_id)
  select name, id from sites where site_group_id is null returning *)
update sites set site_group_id = ids.id from ids where primary_site_id = sites.id;

-- alter table site_groups alter column primary_site_id set not null;

-- Make the sites.site_group_id table not null
alter table sites alter column site_group_id set not null;
