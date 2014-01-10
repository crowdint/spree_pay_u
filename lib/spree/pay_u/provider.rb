module Spree
  module PayU
    class Provider
      attr_reader :client

      def initialize(options = {})
        @client = Client.new(options)
      end

      def actions
        %w(purchase)
      end

      def purchase(money, source, gateway_options = {})
        options = { amount: (money/100), source: source, gateway_options: gateway_options }
        Response.new(client.request(source.class, options))
      end
    end
  end
end