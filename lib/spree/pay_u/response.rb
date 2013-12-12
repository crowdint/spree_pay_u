module Spree
  module PayU
    class Response < ActiveMerchant::Billing::Response
      def initialize(options)
        if options['code'] == 'SUCCESS'
          @success = options['transactionResponse']['state'] == "APPROVED"
          @message = options['transactionResponse']['responseMessage']
          @params  = { message: @message, response_reason_text: options['transactionResponse']['responseCode'] }
        else
          @success = false
          @message = options['error']
          @params  = { message: @message, response_reason_text: @message }
        end
      end
    end
  end
end