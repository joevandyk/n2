require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include N2::CurrentSite
  include Oauth::Models::Consumers::Token
end
