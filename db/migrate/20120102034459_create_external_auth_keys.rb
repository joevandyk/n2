class CreateExternalAuthKeys < ActiveRecord::Migration
  def change
    execute "

-- Maybe this should be in a general site configuration table?

-- facebook, twitter, etc
create table external_auth_sites (
  name text primary key
);

insert into external_auth_sites values ('facebook'), ('twitter');

create table external_auth_keys (
  site_id integer not null references sites(id),
  external_site_type text not null references external_auth_sites(name),
  key text not null,
  secret text not null,
  unique(site_id, external_site_type),
  check (length(key) > 1 and length(secret) > 1)
);

    "

    # From the omniauth providers file, put that information into the db tables.
    APP_CONFIG[:omniauth][:providers].each do |name, info|
      ExternalAuthKey.create!(
        :site               => Site.first,
        :external_site_type => name,
        :key                => info[:key],
        :secret             => info[:secret])
    end
  end
end
