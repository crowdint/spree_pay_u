require 'securerandom'

module Spree
  module PayU
    module Session
      extend self

      def id(account)
        "#{Digest::MD5.hexdigest(SecureRandom.uuid)}#{account}"
      end
    end
  end
end