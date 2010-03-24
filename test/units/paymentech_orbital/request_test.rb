require 'unit_helper'

class RequestTest < Test::Unit::TestCase
  context "Initializing" do
    setup do
      @request = ActiveMerchant::Billing::PaymentechOrbital::Request::Base.new(
        Options(:request_options)
      )
    end

    should "set @options instance variable" do
      assert_not_nil @request.options
    end
  end

  context "A base request" do
    setup do
      @request = base_request
    end

    should "delegate to options" do
      assert_delegates_to_ostruct(@request, @request.options, *[
        :login, :password, :merchant_id, :bin, :terminal_id, :currency_code, 
        :currency_exponent, :customer_ref_num, :order_id
      ])
    end
  end
end
