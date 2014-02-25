Spree::CreditCard.class_eval do
  attr_accessor :device_session_id, :ip_address, :cookie, :user_agent
  attr_accessible :device_session_id, :ip_address, :cookie, :user_agent
end
