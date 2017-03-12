class InvitedTenderNotification < ActiveRecord::Base
  belongs_to :tender
  belongs_to :tender_request_quote

  def self.notification(sc,tender_id,hc,tender_invite_id,message,added_by,trade_id=nil,status=nil)


    if status.present?
      invited = self.new(sc_id: sc, tender_id: tender_id, hc_id: hc, tender_invite_id: tender_invite_id, message: message, added_by: added_by, status: status,trade_id:trade_id)
    else
      invited = self.new(sc_id: sc, tender_id: tender_id, hc_id: hc, tender_invite_id: tender_invite_id, message: message, added_by: added_by,trade_id:trade_id)
    end

    notif = self.where(sc_id: sc, tender_id: tender_id,tender_invite_id: tender_invite_id)

    unless notif.present?
      invited.save
    end
  end
end