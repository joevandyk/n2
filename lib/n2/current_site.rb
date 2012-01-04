module N2
  module CurrentSite
    def self.included klass
      klass.class_eval do
        belongs_to :site


        # This code could be ran before the sites table exists.
        if Site.connection.select_value("select true from pg_tables where tablename = 'sites'").present?
          # The sites table does exist, can safely run this code.
          default_scope do
            begin
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
  end
end
