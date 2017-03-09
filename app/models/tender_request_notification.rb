class TenderRequestNotification < ActiveRecord::Base
  belongs_to :tender
  belongs_to :tender_invite

  def self.notification(sc,tender_id,hc,tender_request_id,message,added_by)
    addenda = self.new(sc_id: sc, tender_id: tender_id, hc_id: hc, tender_request_quote_id: tender_request_id, message: message, added_by: added_by)
    addenda.save
  end
end