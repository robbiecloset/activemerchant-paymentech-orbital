require 'test_helper'

# Auth/capture
# # without profile
# # with profile
# Auth
# # without profile
# # with profile
# Void
# Refund

# Retry logic

class PurchaseTest < Test::Unit::TestCase
  context "Auth/Capture" do
    setup do
      @gateway = remote_gateway
    end

    context "without saved profile" do
      setup do
        @address = Options(:billing_address)
      end

      context "with amex" do
        setup do
          @credit_card = Factory(:amex)
          @response = @gateway.purchase(100, @credit_card, {
            :address => @address,
            :order_id => 1
          })
        end

        should "be successful" do
          assert @response.success?, "should be successful overall"
          assert @response.approved?, "should be approved"
          assert @response.profile_proc_success?, "should save profile"
        end
      end

      context "with discover" do
        setup do
          @credit_card = Factory(:discover)
          @response = @gateway.purchase(100, @credit_card, {
            :address => @address,
            :order_id => 1
          })
        end

        should "be successful" do
          assert @response.success?, "should be successful overall"
          assert @response.approved?, "should be approved"
          assert @response.profile_proc_success?, "should save profile"
        end
      end

      context "with mastercard" do
        setup do
          @credit_card = Factory(:master_card)
          @response = @gateway.purchase(100, @credit_card, {
            :address => @address,
            :order_id => 1
          })
        end

        should "be successful" do
          assert @response.success?, "should be successful overall"
          assert @response.approved?, "should be approved"
          assert @response.profile_proc_success?, "should save profile"
        end
      end

      context "with visa" do
        setup do
          @credit_card = Factory(:visa)
          @response = @gateway.purchase(100, @credit_card, {
            :address => @address,
            :order_id => 1
          })
        end

        should "be successful" do
          assert @response.success?, "should be successful overall"
          assert @response.approved?, "should be approved"
          assert @response.profile_proc_success?, "should save profile"
        end
      end
    end
  end
end
