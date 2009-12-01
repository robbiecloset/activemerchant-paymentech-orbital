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

def end_of_day_request(options={})
  ActiveMerchant::Billing::PaymentechOrbital::Request::EndOfDay.new(
    Options(:end_of_day_options, options)
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

def void_request(tx_ref_num="12345", tx_ref_idx="1", money="100", options={})
  ActiveMerchant::Billing::PaymentechOrbital::Request::Void.new(
    tx_ref_num, tx_ref_idx, money, Options(:void_options, options)
  )
end

def new_order_response(doc=new_order_response_success, request_type="NewOrder", options={})
  ActiveMerchant::Billing::PaymentechOrbital::Response.new(doc, request_type, options)
end

def new_order_response_success
  <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<Response>
<NewOrderResp>
  <IndustryType/>
  <MessageType>AC</MessageType>
  <MerchantID>000000</MerchantID>
  <TerminalID>000</TerminalID>
  <CardBrand>MC</CardBrand>
  <AccountNum>5454545454545454</AccountNum>
  <OrderID>1</OrderID>
  <TxRefNum>4A785F5106CCDC41A936BFF628BF73036FEC5401</TxRefNum>
  <TxRefIdx>1</TxRefIdx>
  <ProcStatus>0</ProcStatus>
  <ApprovalStatus>1</ApprovalStatus>
  <RespCode>00</RespCode>
  <AVSRespCode>B </AVSRespCode>
  <CVV2RespCode>M</CVV2RespCode>
  <AuthCode>tst554</AuthCode>
  <RecurringAdviceCd/>
  <CAVVRespCode/>
  <StatusMsg>Approved</StatusMsg>
  <RespMsg/>
  <HostRespCode>100</HostRespCode>
  <HostAVSRespCode>I3</HostAVSRespCode>
  <HostCVV2RespCode>M</HostCVV2RespCode>
  <CustomerRefNum>2145108</CustomerRefNum>
  <CustomerName>JOE SMITH</CustomerName>
  <ProfileProcStatus>0</ProfileProcStatus>
  <CustomerProfileMessage>Profile Created</CustomerProfileMessage>
  <RespTime>121825</RespTime>
</NewOrderResp>
</Response>
  RESPONSE
end

def new_order_response_failure
  <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<Response>
<QuickResp>
  <ProcStatus>841</ProcStatus>
  <StatusMsg>Error validating card/account number range</StatusMsg>
  <CustomerBin></CustomerBin>
  <CustomerMerchantID></CustomerMerchantID>
  <CustomerName></CustomerName>
  <CustomerRefNum></CustomerRefNum>
  <CustomerProfileAction></CustomerProfileAction>
  <ProfileProcStatus>9576</ProfileProcStatus>
  <CustomerProfileMessage>Profile: Unable to Perform Profile Transaction. The Associated Transaction Failed. </CustomerProfileMessage>
  <CustomerAddress1></CustomerAddress1>
  <CustomerAddress2></CustomerAddress2>
  <CustomerCity></CustomerCity>
  <CustomerState></CustomerState>
  <CustomerZIP></CustomerZIP>
  <CustomerEmail></CustomerEmail>
  <CustomerPhone></CustomerPhone>
  <CustomerProfileOrderOverrideInd></CustomerProfileOrderOverrideInd>
  <OrderDefaultDescription></OrderDefaultDescription>
  <OrderDefaultAmount></OrderDefaultAmount>
  <CustomerAccountType></CustomerAccountType>
  <CCAccountNum></CCAccountNum>
  <CCExpireDate></CCExpireDate>
  <ECPAccountDDA></ECPAccountDDA>
  <ECPAccountType></ECPAccountType>
  <ECPAccountRT></ECPAccountRT>
  <ECPBankPmtDlv></ECPBankPmtDlv>
  <SwitchSoloStartDate></SwitchSoloStartDate>
  <SwitchSoloIssueNum></SwitchSoloIssueNum>
</QuickResp>
</Response>
  RESPONSE
end
