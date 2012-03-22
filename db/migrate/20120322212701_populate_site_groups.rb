class PopulateSiteGroups < ActiveRecord::Migration
  def up
    execute File.read(Rails.root.join("multisite/site_group.sql"))
  end

  def down
  end
end
