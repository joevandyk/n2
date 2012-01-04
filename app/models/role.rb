class Role < ActiveRecord::Base
  include N2::CurrentSite
  acts_as_authorization_role :join_table_name => 'a table here'
end
