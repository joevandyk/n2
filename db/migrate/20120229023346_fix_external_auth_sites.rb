class FixExternalAuthSites < ActiveRecord::Migration
  def up
    execute "insert into external_auth_sites values ('facebook'), ('twitter');"
  end

  def down
  end
end
