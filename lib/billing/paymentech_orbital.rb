require File.dirname(__FILE__) + '/paymentech_orbital/paymentech_orbital_request'

require File.dirname(__FILE__) + '/paymentech_orbital/end_of_day_request'
require File.dirname(__FILE__) + '/paymentech_orbital/new_order_request'
require File.dirname(__FILE__) + '/paymentech_orbital/profile_management_request'
require File.dirname(__FILE__) + '/paymentech_orbital/void_request'

require File.dirname(__FILE__) + '/paymentech_orbital/paymentech_orbital_response'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaymentechOrbitalGateway < Gateway
      cattr_accessor :enable_profile_management, :urls,
                     :currency_code, :currency_exponent,
                     :headers
      
      self.urls = {
        :test => [
          'https://orbitalvar1.paymentech.net/authorize', 
          'https://orbitalvar2.paymentech.net/authorize'
        ], 
        :live => [
          'https://orbital1.paymentech.net/authorize',
          'https://orbital2.paymentech.net/authorize'
        ]
      }
      
      # Currency information for the api.
      self.currency_code = "840"
      self.currency_exponent = "2"
      
      # Money format
      self.money_format = :cents
      
      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = ['US']
      
      # The card types supported by the payment gateway
      self.supported_cardtypes = [:visa, :master, :american_express, :discover]
      
      # The homepage URL of the gateway
      self.homepage_url = 'http://www.example.net/'
      
      # The name of the gateway
      self.display_name = 'Paymentect Orbital Gateway'
      
      # Enable profile management?
      self.enable_profile_management = true
      
      # Headers
      self.headers = {
        "MIME-Version" => "1.0",
        "Content-Type" => "Application/PTI46",
        "Content-transfer-encoding" => "text",
        "Request-number" => "1",
        "Document-type" => "Request"
      }

      attr_reader :request, :response

      def initialize(options = {})
        requires!(options, :login, :password, :merchant_id, :bin, :terminal_id)
        @options = options.merge({
          :currency_code => self.class.currency_code, 
          :currency_exponent => self.class.currency_exponent
        })
        super
      end

      def authorize(money, credit_card=nil, options = {})
        @request = NewOrderRequest.new("A", money, credit_card, options.merge(@options))

        commit('authonly', @request)
      end

      def purchase(money, credit_card=nil, options = {})
        @request = NewOrderRequest.new("AC", money, credit_card, options.merge(@options))

        commit('sale', @request)
      end

      def refund(money, credit_card=nil, options={})
        @request = NewOrderRequest.new("R", money, credit_card, options.merge(@options))

        commit('refund', @request)
      end

      def profile(action, credit_card=nil, options={})
        @request = ProfileManagementRequest.new(action, credit_card, options.merge(@options))

        commit("profile-#{action}", @request)
      end

      def void(tx_ref_num, tx_ref_idx, money=nil, options={})
        @request = VoidRequest.new(tx_ref_num, tx_ref_idx, money, options.merge(@options))

        commit('void', @request)
      end

      def end_of_day(options={})
        @request = EndOfDayRequest.new(options.merge(@options))

        commit('end of day', @request)
      end

      private
      def commit(action, request)
        resp = ssl_post(endpoint_url, request.to_xml, headers)

        @response ||= PaymentechOrbitalResponse.new(resp, request.request_type, {
          :test => test?
        })
      end

      def headers
        self.class.headers.merge(request.headers)
      end

      def endpoint_url
        self.class.urls[Base.gateway_mode][0]
      end

      def enable_profile_management?
        self.class.enable_profile_management
      end
    end
  end
end

