class RequestedTenderNotification < ActiveRecord::Base
  belongs_to :tender


  def self.notification(sc,tender_id,hc,message,added_by)
    requested = self.new(sc_id: sc, tender_id: tender_id, hc_id: hc, message: message, added_by: added_by)
    requested.save
  end
end