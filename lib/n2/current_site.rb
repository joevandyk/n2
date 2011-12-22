module N2
  module CurrentSite
    def self.included klass
      klass.class_eval do
        default_scope do
          if Site.current.blank?
            raise "No site currently selected!"
          else
            where(:site_id => Site.current.id)
          end
        end
      end
    end
  end
end
