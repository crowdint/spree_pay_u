module Spree
  module PayU
    module Request
      class Base
        attr_reader :payload, :connection, :options, :gateway_options, :source

        API_ENDPOINT = '/payments-api/4.0/service.cgi'

        def initialize(connection, options)
          @connection      = connection
          @options         = options
          @gateway_options = options[:gateway_options]
          @source          = options[:source]
        end

        def payload
          common_payload.merge(transaction).to_xml(root: 'request', skip_instruct: true, skip_types: true)
        end

        def test?
          options[:test_mode]
        end

        def create
          Oj.load connection.post(API_ENDPOINT, payload).body
        end


        def transaction
          raise 'Not implemented'
        end

        def common_payload
          {
            language: options[:language],
            command:  'SUBMIT_TRANSACTION',
            isTest:   options[:test_mode],
            merchant:  {
                apiLogin: options[:api_login],
                apiKey: options[:api_key]
            }
          }
        end

        def signature
          to_be_encoded = "#{options[:api_key]}~#{options[:merchant_id]}~#{gateway_options[:order_id]}~#{options[:amount]}~#{gateway_options[:currency]}"
          Digest::MD5.hexdigest(to_be_encoded)
        end

        def order
          {
            referenceCode: gateway_options[:order_id],
            description: 'spree order',
            language: options[:language],
            signature: signature,
            additionalValues: additional_values,
            accountId: options[:account_id],
            notifyUrl: "#{Spree::Config[:site_url]}/pay_u/payments",
            buyer: ''
          }
        end

        def additional_values
          {
            entry: {
              string: 'TX_VALUE',
              additionalValue: {
                value: options[:amount],
                currency: gateway_options[:currency]
              }
            }
          }
        end

        def payer
          {
              fullName: gateway_options[:billing_address][:name],
              emailAddress: gateway_options[:email],
              billingAddress: {
                  street1: gateway_options[:billing_address][:address1],
                  street2: gateway_options[:billing_address][:address2],
                  city: gateway_options[:billing_address][:city],
                  state: gateway_options[:billing_address][:state],
                  country: gateway_options[:billing_address][:country],
                  postalCode: gateway_options[:billing_address][:zip],
                  phone: gateway_options[:billing_address][:phone],
              }
          }
        end
      end
    end
  end
end
