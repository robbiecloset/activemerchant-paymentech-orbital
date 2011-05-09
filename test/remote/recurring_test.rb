require 'remote_helper'

# Recurring:
# Auth/Capture
# x Update MBCancelDate
# Update MBRestoreBillingDate / restore a canceled billing date
# x Update MBRecurringEndDate
# x Update MBRemoveFlag / entirely remove mb info
# x Start late

class RecurringTest < Test::Unit::TestCase
  def teardown; end

  context "Recurring" do
    setup do
      ActiveMerchant::Billing::PaymentechOrbital::Gateway.currency_code = "978"
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:visa)
    end

    should "set start date to future" do
      @@csv << []
      @@csv << ["Starting a recurring payment in the future."]
      @recurring_start_date = (Date.today + 7).strftime("%m%d%Y")
      @purchase = @gateway.purchase(999, @credit_card, {
        :address => @address,
        :mb_type => "R",
        :industry_type => "RC",
        :order_id => @@order_id,
        :recurring_end_date_flag => "N",
        :recurring_frequency => "#{(Date.today + 7).strftime("%d")} * ?",
        :recurring_start_date => @recurring_start_date,
        :mb_type => "R"
      })
      assert @purchase.success?
      @@csv << @gateway.to_a

      @read_response = @gateway.profile(:retrieve, nil, {
        :customer_ref_num => @purchase.customer_ref_num
      })

      assert_equal @recurring_start_date, @read_response.mb_recurring_start_date
    end

    should "remove mb info from a profile" do
      @@csv << []
      @@csv << ["Removing mb info from a profile."]
      @recurring_start_date = (Date.today + 7).strftime("%m%d%Y")
      @purchase = @gateway.purchase(999, @credit_card, {
        :address => @address,
        :mb_type => "R",
        :industry_type => "RC",
        :order_id => @@order_id,
        :recurring_end_date_flag => "N",
        :recurring_frequency => "#{(Date.today + 7).strftime("%d")} * ?",
        :recurring_start_date => @recurring_start_date,
        :mb_type => "R"
      })
      assert @purchase.success?
      @@csv << @gateway.to_a
      @customer_ref_num = @purchase.customer_ref_num

      @read_response = @gateway.profile(:retrieve, nil, {
        :customer_ref_num => @customer_ref_num
      })
      assert @read_response.success?
      assert_equal @recurring_start_date, @read_response.mb_recurring_start_date

      @update_response = @gateway.profile(:update, nil, {
       :customer_ref_num => @customer_ref_num,
       :mb_remove_flag => "Y",
       :mb_type => "R"
      })
      @@csv << @gateway.to_a
      assert @update_response.success?

      @updated_response = @gateway.profile(:retrieve, nil, {
       :customer_ref_num => @customer_ref_num
      })
      assert @updated_response.success?
      assert_nil @updated_response.mb_recurring_start_date
    end

    should "add a recurring end date" do
      @@csv << []
      @@csv << ["Adding a recurring end date"]
      @purchase = @gateway.purchase(999, @credit_card, {
        :address => @address,
        :mb_type => "R",
        :industry_type => "RC",
        :order_id => @@order_id,
        :recurring_end_date_flag => "Y",
        :recurring_frequency => "#{(Date.today + 7).strftime("%d")} * ?",
        :recurring_start_date => (Date.today + 7).strftime("%m%d%Y"),
        :mb_type => "R"
      })
      @@csv << @gateway.to_a
      assert @purchase.success?
      @customer_ref_num = @purchase.customer_ref_num

      @read_response = @gateway.profile(:retrieve, nil, {
        :customer_ref_num => @customer_ref_num
      })
      assert @read_response.success?

      assert_nil @read_response.mb_recurring_end_date

      # Remove mb info
      @remove_response = @gateway.profile(:update, nil, {
       :customer_ref_num => @customer_ref_num,
       :mb_remove_flag => "Y",
       :mb_type => "R"
      })
      @@csv << @gateway.to_a
      assert @remove_response.success?

      @recurring_end_date = "12#{(Date.today + 7).strftime("%d")}2011"
      @update_response = @gateway.profile(:update, nil, {
        :customer_ref_num => @customer_ref_num,
        :mb_order_id_generation_method => "IO",
        :mb_recurring_end_date => @recurring_end_date,
        :mb_recurring_frequency => "#{(Date.today + 7).strftime("%d")} * ?",
        :mb_recurring_start_date => (Date.today + 7).strftime("%m%d%Y"),
        :mb_type => "R"
      })

      @@csv << @gateway.to_a
      assert @update_response.success?

      @updated_response = @gateway.profile(:retrieve, nil, {
        :customer_ref_num => @customer_ref_num
      })

      assert_equal @recurring_end_date, @updated_response.mb_recurring_end_date
    end

    #should "update cancel date" do
    #  @@csv << []
    #  @@csv << ["Cancelling a future, scheduled payment."]

    #  @customer_ref_num = "3461056"
    #  @read_response = @gateway.profile(:retrieve, nil, {
    #    :customer_ref_num => @customer_ref_num,
    #    :mb_type => "R"
    #  })

    #  @update_response = @gateway.profile(:update, nil, {
    #    :customer_ref_num => @customer_ref_num,
    #    :mb_cancel_date => "09132011",
    #    :mb_type => "R"
    #  })
    #  puts @gateway.request.to_xml
    #  puts @update_response.to_xml
    #  @@csv << @gateway.to_a
    #  assert @update_response.success?

    #  @updated_profile = @gateway.profile(:retrieve, nil, {
    #    :customer_ref_num => @customer_ref_num
    #  })
    #  assert @updated_profile.success?
    #end
  end
end
