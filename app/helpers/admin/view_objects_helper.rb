module Admin::ViewObjectsHelper

  def limit_options
    [(1..10).to_a, 15, 20, 25, 30].flatten
  end
  
end
