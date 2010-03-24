module ActiveMerchant
  module Billing
    module PaymentechOrbital
      class Response
        cattr_accessor :elements
        attr_reader :doc, :request_type

        self.elements = [ 
          :industry_type, :message_type, :merchant_id,
          :terminal_id, :card_brand, :account_num, 
          :order_id, :tx_ref_num, :tx_ref_idx, :proc_status,
          :approval_status, :resp_code, :AVSRespCode,
          :CVV2RespCode, :auth_code, :status_msg, :resp_msg,
          :customer_ref_num, :customer_name, :profile_proc_status,
          :customer_profile_message, :resp_time, :batch_seq_num,
          :CCAccountNum, :customer_address_1, :customer_address_2,
          :customer_city, :CustomerZIP, :customer_state,
          :CCExpireDatem, :MBRecurringNoEndDateFlag,
          :MBCancelDate, :MBType, :MBOrderIdGenerationMethod,
          :MBRecurringStartDate, :MBRecurringFrequency, 
          :MBRecurringEndDate, :MBRecurringMaxBillings,
          :MBRemoveFlag
        ]

        def initialize(doc, request_type, options={})
          @doc = REXML::Document.new(doc)
          @request_type = request_type
          @options = options
        end

        def success?
          case request_type
          when "NewOrder"
            proc_success? && approved?
          when "Profile"
            profile_proc_success?
          when "Reversal", "EndOfDay"
            proc_success?
          else
            false
          end
        end

        def proc_success?
          proc_status == "0"
        end

        def profile_proc_success?
          profile_proc_status == "0"
        end

        def approved?
          approval_status == "1"
        end

        def authorization
          approval_status
        end

        def test?
          @options[:test] || false
        end

        def avs_result
          @avs_result ||= AVSResult.new({:code => avs_resp_code})
        end

        def cvv_result
          @cvv_result ||= CVVResult.new({:code => cvv2_resp_code})
        end

        def avs_resp_code
          send(:AVSRespCode)
        end

        def cvv2_resp_code
          send(:CVV2RespCode)
        end

        def mb_cancel_date
          send(:MBCancelDate)
        end

        def mb_recurring_no_end_date_flag
          send(:MBRecurringNoEndDateFlag)
        end
        
        def mb_type
          send(:MBType)
        end
        
        def mb_order_id_generation_method
          send(:MBOrderIdGenerationMethod)
        end
        
        def mb_recurring_start_date
          send(:MBRecurringStartDate)
        end
        
        def mb_recurring_frequency
          send(:MBRecurringFrequency)
        end
        
        def mb_recurring_end_date
          send(:MBRecurringEndDate)
        end
        
        def mb_recurring_max_billings
          send(:MBRecurringMaxBillings)
        end
        
        def mb_remove_flag
          send(:MBRemoveFlag)
        end

        def to_xml
          unless @_xml
            @_xml = ""
            doc.write(@_xml, 2)
          end
          @_xml
        end
        
        def to_a
          [ auth_code, avs_resp_code, cvv2_resp_code, tx_ref_num,
            customer_ref_num, profile_proc_status ]
        end

        private
        def tagify(s)
          s.to_s.gsub(/\/(.?)/) { 
            "::#{$1.upcase}" 
          }.gsub(/(?:^|_)(.)/) { 
            $1.upcase 
          }
        end

        def value_at(sym)
          node = REXML::XPath.first(@doc, "//#{tagify(sym)}")
          node ? node.text : nil
        end

        def method_missing(sym, *args, &blk)
          if self.class.elements.include?(sym)
            value_at(sym)
          else
            super(sym, *args, &blk)
          end
        end
      end
    end
  end
end
