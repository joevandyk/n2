class ChangeExternalAuthSites < ActiveRecord::Migration
  def up
    execute"
alter table external_auth_keys drop constraint external_auth_keys_external_site_type_fkey;
drop table external_auth_sites;

alter table external_auth_keys add constraint site_type_check
  check (external_site_type in ('facebook', 'twitter'));
"
  end

  def down
  end
end
