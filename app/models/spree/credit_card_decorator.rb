Spree::CreditCard.class_eval do
  attr_accessor :device_session_id
  attr_accessible :device_session_id
end
