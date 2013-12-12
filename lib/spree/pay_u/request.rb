module Spree
  module PayU
    module Request
      extend self

      REQUEST_TYPES = {
        Spree::CreditCard => Spree::PayU::Request::CreditCard
      }

      def create(type, connection, options)
        REQUEST_TYPES[type].new(connection, options).create
      end
    end
  end
end