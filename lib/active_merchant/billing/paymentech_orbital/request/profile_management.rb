module ActiveMerchant
  module Billing
    module PaymentechOrbital
      module Request
        class ProfileManagement < PaymentechOrbital::Request::Base
          attr_accessor :action, :credit_card

          cattr_accessor :action_map
          self.action_map = {
            "create"   => "C",
            "retrieve" => "R",
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
          delegate :mb_type, :mb_order_id_generation_method, :mb_recurring_start_date, 
          :mb_recurring_end_date, :mb_recurring_max_billings,
          :mb_recurring_frequency, :mb_deferred_bill_date, :mb_cancel_date, 
          :mb_restore_billing_date, :mb_remove_flag, :to => :options
          
          def customer_profile_action
            self.class.action_map[action.downcase.to_s]
          end
          
          def mb_recurring_no_end_date_flag
            return options[:mb_recurring_no_end_date_flag] if options[:mb_recurring_no_end_date_flag]
            (mb_recurring_end_date || mb_recurring_max_billings) ?
              "N" : "Y"
          end

          def writing?
            ["create", "update"].include?(action)
          end

          def request_body(xml)
            add_meta_info(xml)
            add_profile_info(xml)

            xml.tag! "CustomerProfileAction", customer_profile_action

            add_customer_profile_management_options(xml)
            add_account_info(xml) if writing?
            add_credit_card_info(xml) if writing? && credit_card
            add_managed_billing_info(xml)
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
            xml.tag! "Status", options.status || "A"
          end

          def add_credit_card_info(xml)
            xml.tag! "CCAccountNum", credit_card.number
            xml.tag! "CCExpireDate", "#{credit_card.month}#{credit_card.year}"
          end

          def add_managed_billing_info(xml)
            if mb_type
              xml.tag! "MBType", mb_type
              xml.tag! "MBOrderIdGenerationMethod", mb_order_id_generation_method
              xml.tag! "MBRecurringStartDate", mb_recurring_start_date
              xml.tag! "MBRecurringEndDate", mb_recurring_end_date
              xml.tag! "MBRecurringNoEndDateFlag", mb_recurring_no_end_date_flag
              xml.tag! "MBRecurringMaxBillings", mb_recurring_max_billings
              xml.tag! "MBRecurringFrequency", mb_recurring_frequency
              xml.tag! "MBDeferredBillDate", mb_deferred_bill_date
              xml.tag! "MBCancelDate", mb_cancel_date
              xml.tag! "MBRestoreBillingDate", mb_restore_billing_date
              xml.tag! "MBRemoveFlag", mb_remove_flag
            end
          end
        end
      end
    end
  end
end
