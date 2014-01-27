module Spree
  module PayU
    class PaymentsController < ApplicationController
      def create
        payment = Spree::Payment.find_by_identifier(get_identifier(params[:reference_sale]))
        if params[:response_code_pol] == '1'
          payment.capture!
          Spree::PayUMailer.notify_completed(payment).deliver!
        else
          payment.failure!
          Spree::PayUMailer.notify_rejected(payment, params).deliver!
        end
        render nothing: true
      end

      private

      def get_identifier(reference_sale)
        reference_sale.split('-').last
      end
    end
  end
end
