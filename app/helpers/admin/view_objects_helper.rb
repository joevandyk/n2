module Admin::ViewObjectsHelper

  def limit_options view_object_template = nil
    [(1..10).to_a, 15, 20, 25, 30].flatten
  end

  def select_view_object_template_options
    ViewObjectTemplate.all.map {|t| [t.pretty_name, t.id] }
  end

  def view_object_template_limit_json
    ViewObjectTemplate.all.inject({}) do |list,vot|
      list[vot.id] = {
        :min  => vot.min_items,
        :max  => vot.max_items,
        :name => vot.pretty_name
      }

      list
    end.to_json
  end
  
end
