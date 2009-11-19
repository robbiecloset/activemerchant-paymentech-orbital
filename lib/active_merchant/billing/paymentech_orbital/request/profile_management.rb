module ActiveMerchant
  module Billing
    module PaymentechOrbital
      module Request
        class ProfileManagement < PaymentechOrbital::Request::Base
          attr_accessor :action, :credit_card

          cattr_accessor :action_map
          self.action_map = {
            "create"   => "C",
            "retreive" => "R",
            "update"   => "U",
            "delete"   => "D"
          }

          def initialize(action, credit_card=nil, options={})
            @action = action.to_s
            @credit_card = credit_card
            super(options)
          end

          def request_type; "Profile"; end

          private
          def customer_profile_action(action)
            self.class.action_map[action.downcase.to_s]
          end

          def writing?
            ["create", "update"].include?(action)
          end

          def request_body(xml)
            add_meta_info(xml)
            add_profile_info(xml)

            xml.tag! "CustomerProfileAction", customer_profile_action(action)

            add_customer_profile_management_options(xml)
            add_account_info(xml) if writing?
            add_credit_card_info(xml) if writing? && credit_card
          end

          def add_meta_info(xml)
            xml.tag! "CustomerBin", bin
            xml.tag! "CustomerMerchantID", merchant_id
          end

          def add_profile_info(xml)
            xml.tag! "CustomerName", address[:name]
            xml.tag! "CustomerRefNum", customer_ref_num if customer_ref_num
            xml.tag! "CustomerAddress1", address[:address1]
            xml.tag! "CustomerAddress2", address[:address]
            xml.tag! "CustomerCity", address[:city]
            xml.tag! "CustomerState", address[:state]
            xml.tag! "CustomerZIP", address[:zip]
            xml.tag! "CustomerEmail", address[:email]
            xml.tag! "CustomerPhone", address[:phone]
            xml.tag! "CustomerCountryCode", address[:country]
          end

          def add_customer_profile_management_options(xml)
            unless customer_ref_num
              xml.tag! "CustomerProfileOrderOverrideInd", "NO"
              xml.tag! "CustomerProfileFromOrderInd", "A"
            end
          end

          def add_account_info(xml)
            xml.tag! "CustomerAccountType", "CC"
            xml.tag! "Status", options[:status] || "A"
          end

          def add_credit_card_info(xml)
            xml.tag! "CCAccountNum", credit_card.number
            xml.tag! "CCExpireDate", "#{credit_card.month}#{credit_card.year}"
          end
        end
      end
    end
  end
end