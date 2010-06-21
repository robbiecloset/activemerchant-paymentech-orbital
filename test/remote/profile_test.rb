require 'remote_helper'

# Profile CRUD

class ProfileTest < Test::Unit::TestCase
  context "Profile CRUD" do
    setup do
      @gateway = remote_gateway
      @address = Options(:billing_address)
      @credit_card = Factory(:visa)
    end

    should "create a profile" do
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address,
        :order_default_amount => 100,
        :customer_account_type => "CC",
        :mb_type => "R",
        :mb_recurring_start_date => "12122010",
        :mb_recurring_no_end_date_flag => "Y",
        :mb_recurring_frequency => "12 * ?"
      })

      assert @create_response.success?, "should be successful overall"
      assert @create_response.profile_proc_success?, "should save profile"
    end

    should "read a profile" do
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num

      @read_response = @gateway.profile(:retrieve, nil, {
        :customer_ref_num => @customer_ref_num
      })

      assert_equal @customer_ref_num, @read_response.customer_ref_num
      assert @read_response.success?, "should be successful overall"
      assert @read_response.profile_proc_success?, "should save profile"
    end

    should "update a profile" do
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num

      @new_name = "Smith Joe"

      assert_not_equal @new_name, @create_response.customer_name

      @update_response = @gateway.profile(:update, nil, {
        :address => {
          :name => @new_name
        },
        :customer_ref_num => @customer_ref_num
      })

      assert @update_response.success?, "should be successful overall"
      assert @update_response.profile_proc_success?, "should save profile"
    end

    should "delete a profile" do
      @create_response = @gateway.profile(:create, @credit_card, {
        :address => @address
      })
      @customer_ref_num = @create_response.customer_ref_num

      @delete_response = @gateway.profile(:delete, nil, {
        :customer_ref_num => @customer_ref_num
      })

      assert @delete_response.success?, "should be successful overall"
      assert @delete_response.profile_proc_success?, "should save profile"
    end
  end
end
