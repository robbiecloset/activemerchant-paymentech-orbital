module ActiveMerchant
  module Billing
    module PaymentOrbitalGateway
      module Request
        class NewOrderRequest < ::Request::Base
          attr_reader :message_type, :money, :credit_card, :industry_type

          def initialize(message_type, money, credit_card, options)
            @message_type = message_type
            @money = money
            @credit_card = credit_card
            super(options)
          end

          [:industry_type, :mb_type, :recurring_start_date,
           :recurring_end_date, :recurring_end_date_flag,
           :recurring_max_billings, :recurring_frequency,
           :deferred_bill_date, :soft_descriptors].each do |attr|
            define_method(:"#{attr}") do
              options[:"#{attr}"]
            end
          end

          def request_type; "NewOrder"; end

          def recurring?
            industry_type == "RC"
          end

          private
          def request_body(xml)
            add_meta_info(xml)
            add_credit_card(xml)
            add_billing_address(xml)
            add_profile_management_options(xml)
            add_order_information(xml)
            add_soft_descriptor_info(xml)
            add_managed_billing_info(xml)
          end

          def add_meta_info(xml)
            xml.tag! "IndustryType", industry_type || "EC"
            xml.tag! "MessageType", message_type
            xml.tag! "BIN", bin
            xml.tag! "MerchantID", merchant_id
            xml.tag! "TerminalID", terminal_id
          end

          def add_credit_card(xml)
            if credit_card
              xml.tag! "CardBrand", credit_card.respond_to?(:brand) ? credit_card.brand : credit_card.type
              xml.tag! "AccountNum", credit_card.number
              xml.tag! "Exp", "#{credit_card.month}#{credit_card.year}"
              add_currency(xml)
              xml.tag! "CardSecValInd", "1"
              xml.tag! "CardSecVal", credit_card.verification_value
            else
              xml.tag! "AccountNum", nil
              add_currency(xml)
            end
          end

          def add_currency(xml)
            xml.tag! "CurrencyCode", currency_code
            xml.tag! "CurrencyExponent", currency_exponent
          end

          def add_billing_address(xml)
            xml.tag! "AVSzip", address[:zip]
            if full_street_address.length < 30
              xml.tag! "AVSaddress1", full_street_address
            else
              xml.tag! "AVSaddress1", address[:address1]
              xml.tag! "AVSaddress2", address[:address2]
            end
            xml.tag! "AVScity", address[:city]
            xml.tag! "AVSstate", address[:state]
            xml.tag! "AVSphoneNum" , address[:phone]
            xml.tag! "AVSname", address[:name]
            xml.tag! "AVScountryCode", address[:country]
          end

          def add_profile_management_options(xml)
            if customer_ref_num
              xml.tag! "CustomerRefNum", customer_ref_num
            else
              xml.tag! "CustomerProfileFromOrderInd", "A"
              xml.tag! "CustomerProfileOrderOverrideInd", "NO"
            end
          end

          def add_order_information(xml)
            xml.tag! "OrderID", order_id
            xml.tag! "Amount", money
          end

          def add_soft_descriptor_info(xml)
            if soft_descriptors
              xml.tag! "SDMerchantName", soft_descriptors[:merchant_name]
              xml.tag! "SDProductDescription", soft_descriptors[:production_description]
              xml.tag! "SDMerchantCity", soft_descriptors[:merchant_city]
              xml.tag! "SDMerchantPhone", soft_descriptors[:merchant_phone]
              xml.tag! "SDMerchantURL", soft_descriptors[:merchant_url]
              xml.tag! "SDMerchantEmail", soft_descriptors[:merchant_email]
            end
          end

          def add_managed_billing_info(xml)
            if recurring?
              xml.tag! "MBType", mb_type || "R"
              xml.tag! "MBOrderIdGenerationMethod", "DI"
              xml.tag! "MBRecurringStartDate", recurring_start_date || (Date.today + 1).strftime("%m%d%Y")
              xml.tag! "MBRecurringEndDate", recurring_end_date
              xml.tag! "MBRecurringNoEndDateFlag", recurring_end_date_flag || (recurring_end_date ? "N" : "Y")
              xml.tag! "MBRecurringMaxBillings", recurring_max_billings
              xml.tag! "MBRecurringFrequency", recurring_frequency
              xml.tag! "MBDeferredBillDate", deferred_bill_date
            end
          end
        end
      end
    end
  end
end