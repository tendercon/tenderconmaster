class AddendaNotification < ActiveRecord::Base
  belongs_to :addenda

  def self.notification(sc,tender_id,hc,addenda_id,message,added_by)
    addenda = self.new(sc_id: sc, tender_id: tender_id, hc_id: hc, addenda_id: addenda_id, message: message, added_by: added_by)
    addenda.save
  end

end