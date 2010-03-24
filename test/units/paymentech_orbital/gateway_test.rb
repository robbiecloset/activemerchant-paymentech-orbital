require 'unit_helper'

class GatewayTest < Test::Unit::TestCase
  context "Initializing" do
    [ :login, :password, :merchant_id, :bin, :terminal_id ].each do |attr|
      should "require #{attr}" do
        assert_raises(ArgumentError) do
          gateway(:"#{attr}" => nil)
        end
      end
    end

    should "add currency_exponent to options" do
      assert_not_nil gateway.options[:currency_exponent]
    end

    should "add currency_code to options" do
      assert_not_nil gateway.options[:currency_code]
    end
  end

  context "Authorizing" do
    setup do
      @gateway = gateway
      @credit_card = Factory(:credit_card)
      @gateway.authorize(0, @credit_card)
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::NewOrder" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::NewOrder)
    end
  end

  context "Purchasing" do
    setup do
      @gateway = gateway
      @credit_card = Factory(:credit_card)
      @gateway.purchase(100, @credit_card)
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::NewOrder" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::NewOrder)
    end
  end

  context "Refunding" do
    setup do
      @gateway = gateway
      @credit_card = Factory(:credit_card)
      @gateway.refund(100, @credit_card)
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::NewOrder" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::NewOrder)
    end
  end

  context "Interacting with a saved profile" do
    setup do
      @gateway = gateway
      @gateway.profile(:read, nil)
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::ProfileManagement" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::ProfileManagement)
    end
  end
  
  context "Voiding" do
    setup do
      @gateway = gateway
      @gateway.void("1", "1", 100)
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::Void" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::Void)
    end
  end

  context "Sending an end of day request" do
    setup do
      @gateway = gateway
      @gateway.end_of_day
    end

    should "assign instance variable request" do
      assert_not_nil @gateway.request
    end

    should "instance variable request should be Request::ProfileManagement" do
      assert @gateway.request.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Request::EndOfDay)
    end
  end

  context "Committing" do
    setup do
      @gateway = gateway
      @request = new_order_request
      @gateway.instance_variable_set("@request", @request)
      @gateway.send(:commit, "sale", @request)
    end

    should "assign instance variable response" do
      assert_not_nil @gateway.response
    end

    should "assign an instance of Response::Base as response instance variable" do
      assert @gateway.response.is_a?(ActiveMerchant::Billing::PaymentechOrbital::Response)
    end
  end
end
