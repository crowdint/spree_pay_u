require 'faraday'
require 'typhoeus/adapters/faraday'

module Spree
  module PayU
    class Client
      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def test?
        options[:test_mode]
      end

      def server
        test? ? options[:staging_server] : options[:production_server]
      end

      def connection
        Faraday.new(url: server,  ssl: ssl_options) do |faraday|
          faraday.request :url_encoded
          faraday.headers = headers
          faraday.adapter :typhoeus
        end
      end

      def request(type, gateway_options)
        Request.create(type, connection, gateway_options.merge(options))
      end

      private

      def ssl_options
        test? ? { verify: false } : {}
      end

      def headers
        {
          'Accept'       => 'application/json',
          'Content-type' => 'application/xml'
        }
      end
    end
  end
end