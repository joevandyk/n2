module Admin::ViewObjectsHelper

  def limit_options view_object_template = nil
    [(1..10).to_a, 15, 20, 25, 30].flatten
  end

  def select_view_object_template_options
    ViewObjectTemplate.all.map {|t| [t.pretty_name, t.id] }
  end

  def view_object_classes
    ViewObject.view_object_classes
  end

  def select_view_object_class_options
    view_object_classes.map {|c| [c.name.titleize, c.name] }
  end

  def view_object_class_methods_json
    view_object_classes.inject({}) do |list,klass|
      list[klass.name] = {
        :methods => klass.view_object_scope_methods.map {|m| [m, m.titleize] }
      }

      list
    end.to_json
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

  def view_object_template_limit_range vot
    min, max = vot.min_items, vot.max_items
    if min.nil? and max.nil?
      limit_options
    elsif min and max
      (min..max).to_a
    elsif min.nil?
      min = limit_options.first
      (min..max).to_a
    elsif max.nil?
      max = limit_options.last
      (min..max).to_a
    else
      limit_options
    end
  end
  
end
