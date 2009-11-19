require 'rubygems'
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'activemerchant-paymentech-orbital'
require 'options'
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
end
