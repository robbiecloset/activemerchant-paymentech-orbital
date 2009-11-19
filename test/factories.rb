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

# Pseudo factories
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

def gateway(options={})
  ActiveMerchant::Billing::PaymentechOrbital::Gateway.new(Options(:gateway_auth, options))
end
