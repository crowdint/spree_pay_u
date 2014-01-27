module Spree
  class PayUMailer < BaseMailer
    def notify_completed(payment)
      subject = Spree.t('pay_u.payment.approved')
      mail(to: payment.order.email, from: from_address, subject: subject)
    end

    def notify_rejected(payment, options = {})
      payment_state = options[:response_message_pol].downcase
      subject = Spree.t("pay_u.payment.#{payment_state}")
      mail(to: payment.order.email, from: from_address, subject: subject)
    end
  end
end
