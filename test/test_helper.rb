require 'rubygems'
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'activemerchant-paymentech-orbital'
require 'mocks/active_merchant/billing/gateway'
require 'test/unit'
require 'shoulda'
require 'factory_girl'
require 'rr'

ActiveMerchant::Billing::Base.mode = :test

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def assert_delegates(delegator, delegatee, *methods)
    methods.each do |method|
      mock(delegatee).send(:"#{method}")
      delegator.send(:"#{method}")
    end
  end

  # Pseudo factories
  def gateway(options={})
    ActiveMerchant::Billing::PaymentechOrbital::Gateway.new({
      :login       => "user",
      :password    => "mytestpass",
      :merchant_id => "1",
      :bin         => "1", 
      :terminal_id => "1"
    }.merge(options).delete_if { |k,v| 
      v.nil?
    })
  end
end
