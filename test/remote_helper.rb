require 'test_helper'
require 'faster_csv'
require 'yaml'

class Test::Unit::TestCase
  @@csv = nil
  @@order_id = 0

  def setup
    @certification_file = "certification.csv"

    unless @@csv
      @@csv = FasterCSV.open(@certification_file, "w")
      @@csv << [ 
        "Request Type", "Date/Time", "MerchantID", "Order #", 
        "IndustryType", "Amount", "Currency", "CustomerRefNum",
        "Phone", "Name", "Address", "Auth Code", "AVSResp",
        "CSVResp", "TxRefNum", "CustomerRefNum", "ProfileProcStatus"
      ]
    end

    @@order_id = @@order_id + 1
  end

  def teardown
    @@csv << @gateway.to_a
  end
end
