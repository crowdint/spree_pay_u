module Spree
  class Gateway::PayU::CreditCard < Gateway
    preference :staging_server, :string, default: 'https://stg.api.payulatam.com'
    preference :production_server, :string, default: 'https://api.payulatam.com'
    preference :language, :string, default: 'es'
    preference :api_key, :string
    preference :api_login, :string
    preference :merchant_id, :string
    preference :account_id, :string

    attr_accessible :preferred_staging_server, :preferred_production_server, :preferred_language,
                    :preferred_api_key, :preferred_api_login, :preferred_merchant_id, :preferred_account_id

    delegate :authorize, :capture, to: :provider

    def provider_class
      Spree::PayU::Provider
    end

    def auto_capture?
      false
    end

    def method_type
      'pay_u_credit_card'
    end
  end
end
