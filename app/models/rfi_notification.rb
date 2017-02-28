class RfiNotification < ActiveRecord::Base
  belongs_to :rfi
  belongs_to :tender


  def self.create_rfi_notification(sc,tender_id,hc,rfi_id,message,added_by)
    rfi = RfiNotification.new(sc_id: sc, tender_id: tender_id, hc_id: hc, rfi_id: rfi_id, message: message, added_by: added_by)
    rfi.save
  end

end