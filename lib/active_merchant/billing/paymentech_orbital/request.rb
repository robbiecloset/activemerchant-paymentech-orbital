require 'ostruct'

module ActiveMerchant
  module Billing
    module PaymentechOrbital
      module Request
        class Base
          attr_reader :gateway, :options

          def initialize(options={})
            @options = OpenStruct.new(options)
          end

          def to_xml
            @_xml ||= build_request
          end
          alias :xml :to_xml

          def headers
            @_headers ||= options.headers || {}
          end

          def to_a
            [ to_s, Time.now, merchant_id, order_id, industry_type,
              money, currency_code, customer_ref_num, address[:phone],
              address[:name], full_street_address ]
          end

          def address
            @_address ||= options.billing_address || options.address || {}
          end

          delegate :login, :password, :merchant_id, 
            :bin, :terminal_id, :currency_code, 
            :currency_exponent, :customer_ref_num, 
            :order_id, :to => :options

          def full_street_address
            "#{address[:address1]} #{address[:address2]}".strip
          end

          private

          # Implement me. I should be the parent tag for the request.
          def request_type; "RequestType"; end

          def build_request
            xml = Builder::XmlMarkup.new(:indent => 2)

            xml.instruct!(:xml, :version => '1.0', :encoding => 'UTF-8')
            xml.tag! "Request" do
              xml.tag! request_type do
                add_authentication(xml)

                request_body(xml)
              end
            end

            xml.target!
          end

          # Implement me. I should take the provided
          # xml builder and add tags to the request.
          def request_body(xml); xml; end

          def add_authentication(xml)
            xml.tag! "OrbitalConnectionUsername", login
            xml.tag! "OrbitalConnectionPassword", password
          end
        end
      end
    end
  end
end