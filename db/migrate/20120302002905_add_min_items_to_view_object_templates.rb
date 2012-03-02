class AddMinItemsToViewObjectTemplates < ActiveRecord::Migration
  def change
    add_column :view_object_templates, :min_items, :integer, :default => nil
    add_column :view_object_templates, :max_items, :integer, :default => nil
  end
end
