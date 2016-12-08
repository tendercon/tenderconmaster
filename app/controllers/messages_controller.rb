class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @tender_id = params[:tender]
    @trade = params[:trade]
    @sc_id = params[:sc]
    @tender_approved_trade = TenderApprovedTrade.where(:tender_id => @tender_id,:trade_id => @trade,:sc_id => @sc_id).first
    @group_approved_trades = TenderApprovedTrade.where(:tender_id => @tender_id,:trade_id => @trade)

    puts "@group_approved_trades:#{@group_approved_trades.inspect}"
  end

  def create_channel
    scs = params[:scs]
    trades = params[:trades]
    tender_id = params[:tender_id]
    group_name = params[:val]

    if scs.present?
      scs.each_with_index do |t,index|

        tender_request = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => t)

        if tender_request.present?
          tender_request.each do |a|

            message = Message.new
            message.tender_id = tender_id
            message.sc_id = t
            message.hc_id = a.hc_id
            message.trade_id = trades[index]
            message.group_name = group_name
            message.channel = "channel_#{tender_id}_#{trades[index]}_#{a.hc_id}_#{t}"
            message.save
          end
        end
      end
    end

    @user_array = []
    @user_array01 = []
    @trade_requests = []
    if session[:role] == 'Head Contractor'
      @approved_quotes = TenderApprovedTrade.where(:tender_id => tender_id,:hc_id => session[:user_logged_id])
    else
      @approved_quotes = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => session[:user_logged_id])
    end


    if @approved_quotes.present?
      @approved_quotes.each do |t|
        @trade_requests << t.trade_id
      end
    end

    @group_approved_trades = TenderApprovedTrade.where(:tender_id => tender_id,:trade_id => @trade_requests)

    @group_name = []

    if session[:role] == 'Head Contractor'
      @messages = Message.where(:tender_id => tender_id,:hc_id => session[:user_logged_id])
    else
      @messages = Message.where(:tender_id => tender_id,:sc_id => session[:user_logged_id])
    end


    @message_chats = MessageChat.where(:tender_id => tender_id,:to_id => session[:user_logged_id])


    @data = render :partial => 'messages/start_chat'
  end

  def save_messages
    tender_id = params[:tender_id]
    channel = params[:new_channel].present? ? params[:new_channel] : params[:channel]
    message = params[:message]
    puts "CHANNEL:#{channel}"
    scs = []
    hcs = []
    messages = Message.where(:tender_id => tender_id,:group_name => channel)

    if messages.present?
      messages.each do |a|
        scs << a.sc_id
        hcs << a.hc_id
      end
    end
    puts "scs:#{scs}"
    puts "hcs:#{hcs[0]}"
    puts "session[:user_logged_id]:#{session[:user_logged_id]}"
    if session[:user_logged_id] == hcs[0]
      if scs.present?
        scs.uniq.each do |c|
          chat = MessageChat.new
          chat.tender_id = tender_id
          if params[:new_channel].present?
            chat.group_name = params[:new_channel]
          else
            chat.group_name = channel
          end
          chat.to_id = c
          chat.from_id = hcs[0]
          chat.message = message
          chat.status = 'unread'
          if params[:new_channel].present?

          end
          chat.save
        end
      end
    else
      if scs.uniq.include? session[:user_logged_id]
        if scs.present?
          scs << hcs[0]
          scs.uniq.each do |c|
            if c != session[:user_logged_id]
              chat = MessageChat.new
              chat.tender_id = tender_id
              if params[:new_channel].present?
                chat.group_name = params[:new_channel]
              else
                chat.group_name = channel
              end
              chat.to_id = c
              chat.from_id = session[:user_logged_id]
              chat.message = message
              chat.status = 'unread'
              chat.save
            end

          end
        end
      else
        if session[:user_logged_id] == params[:sc_id]
          [1].each do |a|
            puts "IF"
            chat = MessageChat.new
            chat.tender_id = tender_id
            if params[:new_channel].present?
              chat.group_name = params[:new_channel]
            else
              chat.group_name = channel
            end

            chat.to_id = params[:hc_id]
            chat.from_id = session[:user_logged_id]
            chat.message = message
            chat.status = 'unread'
            chat.save
          end
        else
          [1].each do |a|
            puts "ELSE"
            chat = MessageChat.new
            chat.tender_id = tender_id
            if params[:new_channel].present?
              chat.group_name = params[:new_channel]
            else
              chat.group_name = channel
            end
            chat.to_id = params[:sc_id]
            chat.from_id = session[:user_logged_id]
            chat.message = message
            chat.status = 'unread'
            chat.save
          end

        end

      end

    end
    message_chat = MessageChat.where(:tender_id => tender_id,:group_name => channel).last
    render :json => { :state => 'valid',:channel => channel,:message_time => (message_chat.created_at).strftime('%H:%M %p'),:message_text => message_chat.message}

  end

  def update_unread_messages
    messages = MessageChat.where(:to_id => params[:id],:tender_id => params[:tender_id],:group_name => params[:group_name])
    message_last = MessageChat.where(:to_id => params[:id],:tender_id => params[:tender_id],:group_name => params[:group_name]).last

    if messages.present?
      messages.each do |m|
        MessageChat.where(:id => m.id).update_all(:status => 'read')
      end
    end
    if message_last.present?
      MessageChat.where("id != #{message_last.id} and to_id = #{params[:id]}").destroy_all
      render :json => { :state => 'valid',:message_id => message_last.id}
    else
      render :json => { :state => 'valid'}
    end

  end

  def get_user_lists
    group_name = params[:group_name]
    tender_id = params[:tender_id]

    scs = []
    hcs = []
    messages = Message.where(:tender_id => tender_id,:group_name => group_name)

    if messages.present?
      messages.each do |a|
        scs << a.sc_id
        hcs << a.hc_id
      end
    end

    user_company_array = []
    user_logged_status_array = []
    if scs.present?
      scs << hcs[0]

      scs.uniq.each do |s|

        user = User.find(s)
        user_company_array << user.company
        if user.logged_status == nil
          user_logged_status_array << 'offline'
        else
          user_logged_status_array << user.logged_status
        end


      end
    end
    puts "user_company_array:#{user_company_array.inspect}"
    puts "user_logged_status_array:#{user_logged_status_array.inspect}"
    render :json => { :state => 'valid',:users => user_company_array, :status => user_logged_status_array}
  end

end