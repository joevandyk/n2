# Most (if not all?) of our models should be including the N2::CurrentSite module.
# This will add a default_scope of the current site_id to everything.
module N2
  module CurrentSite
    def self.included klass
      klass.class_eval do
        belongs_to :site
        before_save :update_my_site_id

        define_method :update_my_site_id do
          self.site_id = Site.current.id
        end

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


# Translations / Locale stuff also needs to be scoped by site.
# TODO Should probably go somewhere else
class Translation
  include N2::CurrentSite
end

class I18n::Backend::Locale
  include N2::CurrentSite
end

class Slug
  include N2::CurrentSite
end
