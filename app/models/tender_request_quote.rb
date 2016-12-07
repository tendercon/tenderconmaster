class TenderRequestQuote < ActiveRecord::Base
  belongs_to :tender
  has_many :tender_request_trades


  def self.check_sc_tender_trade_exists? tender_id,trade_id,sc_id,hc_id

    tender = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => sc_id,:hc_id => hc_id,:trade_id => trade_id).first

    if tender.present?
      true
    else
      false
    end

  end

end