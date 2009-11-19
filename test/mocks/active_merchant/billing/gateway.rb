module ActiveMerchant #:nodoc:
  module Billing
    class Gateway
      def ssl_request(*args)
        "<xml></xml>"
      end
    end
  end
end
