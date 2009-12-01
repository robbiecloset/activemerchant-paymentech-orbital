require 'test_helper'

class NewOrderTest < Test::Unit::TestCase
  context "Initializing" do
    setup do
      @request = new_order_request
    end

    [ :message_type, :money, :credit_card, :options ].each do |attr|
      should "set @#{attr} instance variable" do
        assert_not_nil @request.send(attr)
      end
    end
  end

  context "A base request" do
    setup do
      @request = new_order_request
    end

    should "delegate to options" do
      assert_delegates_to_ostruct(@request, @request.options, *[
        :industry_type, :mb_type, :recurring_start_date,
        :recurring_end_date, :recurring_end_date_flag,
        :recurring_max_billings, :recurring_frequency,
        :deferred_bill_date, :soft_descriptors
      ])
    end

    should "be recurring if industry_type is RC" do
      assert new_order_request(:industry_type => "RC").recurring?
    end

    should "not be recurring if industry_type is RC" do
      assert !new_order_request(:industry_type => "EC").recurring?
    end
  end
end
