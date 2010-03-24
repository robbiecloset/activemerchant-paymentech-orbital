require 'remote_helper'

class RefundTest < Test::Unit::TestCase
  context "Refund" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
    end

    context "with amex" do
      setup do
        @credit_card = Factory(:amex)
        @profile = @gateway.profile(:create, @credit_card, {
          :address => @address
        })

        @response = @gateway.refund(999, nil, {
          :customer_ref_num => @profile.customer_ref_num,
          :order_id => @@order_id
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
        @profile = @gateway.profile(:create, @credit_card, {
          :address => @address
        })
        @response = @gateway.refund(999, nil, {
          :customer_ref_num => @profile.customer_ref_num,
          :order_id => @@order_id
        })
      end

      should "be successful" do
        assert @response.success?, "should be successful overall"
        assert @response.approved?, "should be approved"
        assert @response.profile_proc_success?, "should save profile"
      end
    end

    context "with master_card" do
      setup do
        @credit_card = Factory(:master_card)
        @profile = @gateway.profile(:create, @credit_card, {
          :address => @address
        })
        @response = @gateway.refund(999, nil, {
          :customer_ref_num => @profile.customer_ref_num,
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
        @profile = @gateway.profile(:create, @credit_card, {
          :address => @address
        })
        @response = @gateway.refund(999, nil, {
          :customer_ref_num => @profile.customer_ref_num,
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
