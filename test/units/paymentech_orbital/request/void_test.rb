require 'unit_helper'

class VoidTest < Test::Unit::TestCase
  context "Initializing" do
    setup do
      @request = void_request
    end

    [ :tx_ref_num, :tx_ref_idx, :money, :options ].each do |attr|
      should "set @#{attr} instance variable" do
        assert_not_nil @request.send(attr)
      end
    end
  end

  context "A base request" do
    setup do
      @request = void_request
    end

    should "delegate to options" do
      assert_delegates_to_ostruct(@request, @request.options, *[
        :login, :password, :merchant_id, :bin, :terminal_id, :currency_code, 
        :currency_exponent, :customer_ref_num, :order_id
      ])
    end
  end
end
