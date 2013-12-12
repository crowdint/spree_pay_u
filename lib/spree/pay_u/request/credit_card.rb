module Spree
  module PayU
    module Request
      class CreditCard < Base
        def transaction
          {
            transaction: {
              order: order,
              creditCard: credit_card,
              type: 'AUTHORIZATION_AND_CAPTURE',
              paymentMethod: source.cc_type.try(:upcase),
              extraParameters: extra_parameters
            }
         }
        end

        private

        def credit_card
          {
            number: source.number,
            securityCode: source.verification_value,
            expirationDate: "#{source.year}/#{source.month}",
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
      end
    end
  end
end