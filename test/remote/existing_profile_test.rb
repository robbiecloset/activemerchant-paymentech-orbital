require 'remote_helper'

# With existing profile:
# Auth/Capture: AX
#  Void the above
# Auth/Capture: MC
#  Void the above
# Auth/Capture: DI
#  Void the above
# Auth/Capture: VI
#  Void the above

class ProfileTest < Test::Unit::TestCase
  context "With an amex" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:amex)
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num
    end
    
    should "perform an auth/capture then void it" do
      @purchase_response = @gateway.purchase(100, nil, {
        :customer_ref_num => @customer_ref_num,
        :order_id => @@order_id
      })

      assert @purchase_response.success?, "should be successful overall"
      assert @purchase_response.approved?, "should be approved"
      assert @purchase_response.profile_proc_success?, "should save profile"

      @@csv << @gateway.to_a

      @void_response = @gateway.void(@purchase_response.tx_ref_num, @purchase_response.tx_ref_idx, nil, {
        :order_id => @@order_id
      })

      assert @void_response.success?, "should be successful overall"
    end
  end
  
  context "With a discover" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:discover)
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num
    end
    
    should "perform an auth/capture then void it" do
      @purchase_response = @gateway.purchase(100, nil, {
        :customer_ref_num => @customer_ref_num,
        :order_id => @@order_id
      })

      assert @purchase_response.success?, "should be successful overall"
      assert @purchase_response.approved?, "should be approved"
      assert @purchase_response.profile_proc_success?, "should save profile"

      @@csv << @gateway.to_a

      @void_response = @gateway.void(@purchase_response.tx_ref_num, @purchase_response.tx_ref_idx, nil, {
        :order_id => @@order_id
      })

      assert @void_response.success?, "should be successful overall"
    end
  end

  context "With a master_card" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:master_card)
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num
    end
    
    should "perform an auth/capture then void it" do
      @purchase_response = @gateway.purchase(100, nil, {
        :customer_ref_num => @customer_ref_num,
        :order_id => @@order_id
      })

      assert @purchase_response.success?, "should be successful overall"
      assert @purchase_response.approved?, "should be approved"
      assert @purchase_response.profile_proc_success?, "should save profile"

      @@csv << @gateway.to_a

      @void_response = @gateway.void(@purchase_response.tx_ref_num, @purchase_response.tx_ref_idx, nil, {
        :order_id => @@order_id
      })

      assert @void_response.success?, "should be successful overall"
    end
  end

  context "With a visa" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:visa)
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num
    end
    
    should "perform an auth/capture then void it" do
      @purchase_response = @gateway.purchase(100, nil, {
        :customer_ref_num => @customer_ref_num,
        :order_id => @@order_id
      })

      assert @purchase_response.success?, "should be successful overall"
      assert @purchase_response.approved?, "should be approved"
      assert @purchase_response.profile_proc_success?, "should save profile"

      @@csv << @gateway.to_a

      @void_response = @gateway.void(@purchase_response.tx_ref_num, @purchase_response.tx_ref_idx, nil, {
        :order_id => @@order_id
      })

      assert @void_response.success?, "should be successful overall"
    end
  end
end
