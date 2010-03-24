require 'remote_helper'

class AuthTest < Test::Unit::TestCase
  context "Auth" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
    end

    context "with mastercard" do
      setup do
        @credit_card = Factory(:master_card)
        @response = @gateway.authorize(000, @credit_card, {
          :address => @address,
          :order_id => @@order_id
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
        @response = @gateway.authorize(000, @credit_card, {
          :address => @address,
          :order_id => @@order_id
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
