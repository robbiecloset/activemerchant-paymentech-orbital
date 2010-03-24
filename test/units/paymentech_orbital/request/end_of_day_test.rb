require 'unit_helper'

class EndOfDayTest < Test::Unit::TestCase
  context "Initializing" do
    setup do
      @request = end_of_day_request
    end

    [ :options ].each do |attr|
      should "set @#{attr} instance variable" do
        assert_not_nil @request.send(attr)
      end
    end
  end

  context "A base request" do
    setup do
      @request = end_of_day_request
    end

    should "delegate to options" do
      assert_delegates_to_ostruct(@request, @request.options, *[
        :login, :password, :merchant_id, 
        :bin, :terminal_id, :currency_code, 
        :currency_exponent, :customer_ref_num, 
        :order_id
      ])
    end
  end
end
