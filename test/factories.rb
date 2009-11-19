Factory.define :credit_card, {
  :class => ActiveMerchant::Billing::CreditCard,
  :default_strategy => :build
} do |f|
  f.number "4242424242424242"
  f.month 9
  f.year Time.now.year + 1
  f.first_name 'Longbob'
  f.last_name 'Longsen'
  f.verification_value '123'
  f.add_attribute :type, 'visa'
end
