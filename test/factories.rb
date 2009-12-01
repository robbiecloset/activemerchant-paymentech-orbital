Factory.define :credit_card, {
  :class => ActiveMerchant::Billing::CreditCard,
  :default_strategy => :build
} do |f|
  f.number "4242424242424242"
  f.month 9
  f.year Time.now.year + 1
  f.first_name 'Joe'
  f.last_name 'Smith'
  f.verification_value '123'
  f.add_attribute :type, 'visa'
end

# Option factories
Options.define(:billing_address, :defaults => {
  :zip => "12345",
  :address1 => "123 Happy Place",
  :address2 => "Apt 1",
  :city => "SuperVille",
  :state => "NY",
  :name => "Joe Smith",
  :country => "US"
})
Options.define(:gateway_auth, :defaults => {
  :login       => "user",
  :password    => "mytestpass",
  :merchant_id => "1",
  :bin         => "1", 
  :terminal_id => "1"
})
Options.define(:soft_descriptors, :defaults => {
  :merchant_name => 'merchant',
  :merchant_url => 'mmmerchant.com'
})

# Request options:
Options.define(:request_options, :parent => :gateway_auth)
Options.define(:end_of_day_options, :parent => :request_options)
Options.define(:new_order_options, :parent => [
  :request_options, :billing_address, :soft_descriptors
], :defaults => {
  :currency_code => "840",
  :currency_exponent => "2",
  :order_id => "1",
  :recurring_frequency => "#{Date.today.strftime("%d")} * ?"
})
Options.define(:profile_management_options, :parent => [
  :request_options, :billing_address
], :defaults => {
  :customer_ref_num => "123456"
})
Options.define(:void_options, :parent => :request_options, :defaults => {
  :tx_ref_num => "1", 
  :tx_ref_idx => "1",
  :order_id => "1"
})

# Pseudo factories
def gateway(options={})
  ActiveMerchant::Billing::PaymentechOrbital::Gateway.new(Options(:gateway_auth, options))
end

def base_request(options={})
  ActiveMerchant::Billing::PaymentechOrbital::Request::Base.new(
    Options(:request_options, options)
  )
end

def new_order_request(options={})
  ActiveMerchant::Billing::PaymentechOrbital::Request::NewOrder.new(
    "AC", 100, Factory(:credit_card), Options(:new_order_options, options)
  )
end

def profile_management_request(action=:create, credit_card=Factory(:credit_card), options={})
  ActiveMerchant::Billing::PaymentechOrbital::Request::ProfileManagement.new(
    action, credit_card, Options(:profile_management_options, options)
  )
end
