module Spree
  module PayU
    module Request
      class CreditCard < Base
        CREDIT_CARD_TYPES = {
          'visa'               => 'VISA',
          'master'             => 'MASTERCARD',
          'american_express'   => 'AMEX',
          'diners_club'        => 'DINERS',
        }

        def transaction
          {
            transaction: {
              order: order,
              creditCard: credit_card,
              type: 'AUTHORIZATION_AND_CAPTURE',
              paymentMethod: cc_type(source),
              extraParameters: extra_parameters
            }
         }
        end

        private

        def credit_card
          {
            number: source.number,
            securityCode: source.verification_value,
            expirationDate: "#{source.year}/#{source.month.to_s.rjust(2, '0')}",
            name: credit_card_name
          }
        end

        def extra_parameters
          # HACK to be able to have 2 or more keys of the same value in a hash
          hash = {}
          hash[:entry] = {}.compare_by_identity
          hash[:entry]["string"] = 'INSTALLMENTS_NUMBER'
          hash[:entry]["string"] = '1'
          hash
        end

        def credit_card_name
          test? ? 'APPROVED' : source.name
        end

        def cc_type(source)
          CREDIT_CARD_TYPES[source.cc_type]
        end
      end
    end
  end
end