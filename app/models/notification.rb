class Notification < ActiveRecord::Base
  belongs_to :user

  def self.notification_count user_id
    user = User.find(user_id)
    total = 0
    if user.role == 'Head Contractor'
      @rfi_notifs = RfiNotification.where("hc_id = #{user.id} and added_by='SC'")
      @quote_notifs = QuoteNotification.where(:hc_id => user.id)
      @invited_notifs = InvitedTenderNotification.where(:hc_id => user.id, :added_by => "SC")
      @requested_tender_notifications = RequestedTenderNotification.where(:hc_id => user.id, :added_by => "SC")
      total = (@rfi_notifs.present? ? @rfi_notifs.size : 0) + (@quote_notifs.present? ? @quote_notifs.size : 0)  + (@invited_notifs.present? ? @invited_notifs.size : 0)  + (@requested_tender_notifications.present? ? @requested_tender_notifications.size : 0)
    else
      @rfi_notifs = RfiNotification.where("sc_id = #{user.id} and added_by='HC'")
      @addenda_notifs = AddendaNotification.where("sc_id = #{user.id} and added_by='HC'")
      @invited_notifs = InvitedTenderNotification.where(:sc_id => user.id, :added_by => "HC")
      @tender_request_quote_notifs = TenderRequestNotification.where("sc_id = #{user.id} and added_by='HC'")
      total = (@rfi_notifs.present? ? @rfi_notifs.size : 0) + (@addenda_notifs.present? ? @addenda_notifs.size : 0) + (@tender_request_quote_notifs.present? ? @tender_request_quote_notifs.size : 0) + (@invited_notifs.present? ? @invited_notifs.size : 0)
    end
    total
  end
end