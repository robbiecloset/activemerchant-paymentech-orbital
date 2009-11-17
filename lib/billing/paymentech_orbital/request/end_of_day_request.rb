class EndOfDayRequest < PaymentechOrbitalRequest
  def request_type; "EndOfDay"; end

  private
  def request_body(xml)
    add_meta_info(xml)
  end

  def add_meta_info(xml)
    xml.tag! "BIN", bin
    xml.tag! "MerchantID", merchant_id
    xml.tag! "TerminalID", terminal_id
  end
end