module Spree
  module PayU
    class Provider
      attr_reader :client

      def initialize(options = {})
        @client = Client.new(options)
      end

      def actions
        %w(authorize capture)
      end

      def authorize(money, source, gateway_options = {})
        options = { amount: (money/100), source: source, gateway_options: gateway_options }
        Response.new(client.request(source.class, options))
      end

      def capture(money, source, gateway_options)
        ActiveMerchant::Billing::Response.new(true, '')
      end
    end
  end
end
