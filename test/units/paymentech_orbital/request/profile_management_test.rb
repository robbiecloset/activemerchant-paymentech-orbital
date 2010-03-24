require 'unit_helper'

class ProfileManagementTest < Test::Unit::TestCase
  context "Initializing" do
    setup do
      @request = profile_management_request
    end

    [ :action, :credit_card, :options ].each do |attr|
      should "set @#{attr} instance variable" do
        assert_not_nil @request.send(attr)
      end
    end
  end

  context "A base request" do
    setup do
      @request = profile_management_request
    end

    should "delegate to options" do
      assert_delegates_to_ostruct(@request, @request.options, *[
        :login, :password, :merchant_id, 
        :bin, :terminal_id, :currency_code, 
        :currency_exponent, :customer_ref_num, 
        :order_id, :mb_type, :mb_order_id_generation_method, 
        :mb_recurring_start_date, :mb_recurring_end_date, 
        :mb_recurring_max_billings, :mb_recurring_frequency, 
        :mb_deferred_bill_date, :mb_cancel_date, 
        :mb_restore_billing_date, :mb_remove_flag
      ])
    end

    should "return a different customer profile action based its action instance variable" do
      assert_equal "C", profile_management_request(:create).send(:customer_profile_action)
      assert_equal "R", profile_management_request(:retrieve).send(:customer_profile_action)
      assert_equal "U", profile_management_request(:update).send(:customer_profile_action)
      assert_equal "D", profile_management_request(:delete).send(:customer_profile_action)
    end

    should "be writing? when action is create or update" do
      assert profile_management_request(:create).send(:writing?)
      assert profile_management_request(:update).send(:writing?)
    end

    should "not be writing? when action is retrieve or delete" do
      assert !profile_management_request(:retrieve).send(:writing?)
      assert !profile_management_request(:delete).send(:writing?)
    end
  end
end
