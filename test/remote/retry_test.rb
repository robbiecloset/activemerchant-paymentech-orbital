require 'remote_helper'

# Retry:
# Auth/Capture: Trace = 1
# Auth/Capture: Trace = 1
# Auth/Capture: Trace = 1

class RetryTest < Test::Unit::TestCase
  def teardown; end

  context "With a visa" do
    setup do
      ActiveMerchant::Billing::PaymentechOrbital::Gateway.currency_code = "978"
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:visa)
    end

    should "prevent prevent duplicate requests when provided same trace number" do
      @purchase_response = @gateway.purchase(999, @credit_card, {
        :address => @address,
        :headers => {
          "Trace-number" => "1"
        },
        :order_id => @@order_id
      })
      assert @purchase_response.success?, "should be successful overall"
      assert @purchase_response.approved?, "should be approved"
      assert @purchase_response.profile_proc_success?, "should save profile"
      row = @gateway.to_a
      row.shift
      @@csv << row.unshift("Auth/Capture: Trace = 1")

      @auth_code = @purchase_response.auth_code

      2.times { |n|
        dupe_response = @gateway.purchase(999, @credit_card, {
          :address => @address,
          :headers => {
            "Trace-number" => "1"
          },
          :order_id => @@order_id
        })
        assert_equal @auth_code, dupe_response.auth_code

        row = @gateway.to_a
        row.shift
        @@csv << row.unshift("Auth/Capture: Trace = 1")
      }
    end
  end
end
