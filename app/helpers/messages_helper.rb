module MessagesHelper

  def get_unread_messages tender_id,to_id,group_name
    messages = MessageChat.where("tender_id = #{tender_id} and group_name='#{group_name}' and status='unread' and to_id = #{to_id}").count()

    if messages.present?
      messages
    else
      0
    end
  end

  def get_unread_tender_messages tender_id,to_id,group_name
    messages = MessageChat.where("tender_id = #{tender_id} and group_name='#{group_name}' and (to_id = #{to_id} OR from_id = #{to_id})")

    if messages.present?
      messages
    else
      nil
    end
  end

  def get_user_list_on_group group_name,tender_id
    scs = []
    hcs = []
    messages = Message.where(:tender_id => tender_id,:group_name => group_name)

    if messages.present?
      messages.each do |a|
        scs << a.sc_id
        hcs << a.hc_id
      end
    end

    online_array = []
    offline_array = []
    if scs.present?
      scs << hcs[0]
      scs.uniq.each do |s|
        begin
          user = User.find(s)
          if user.present?
            if user.logged_status == 'online'
              online_array << user.id
            else
              offline_array << user.id
            end
          end
        rescue
          nil
        end
      end
    end
    return online_array + offline_array
  end
end