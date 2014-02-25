require 'securerandom'

module Spree
  module PayU
    class Session
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def id
        "#{Digest::MD5.hexdigest(SecureRandom.uuid)}"
      end

      def ip
        request.ip
      end

      def user_agent
        request.user_agent
      end

      def cookie
        request.cookies['_session_id']
      end
    end
  end
end
