class HcInvitesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @trades = Trade.all
    @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil)
  end

  def add_savvy
    hc_invite = HcInvite.new(hc_invites_permitted_params)
    user = User.where(:email => params[:email]).first

    if user.present?
      hc_invite.user_id = user.id
    end

    if hc_invite.save
      @trades = Trade.all
      @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil)
      unless user.present?
        decline_path = "http://"+request.host_with_port+"/invites/decline_tender_invite?&email=#{hc_invite.email}&trade=#{hc_invite.trade_id}"
        path = "http://"+request.host_with_port+"/users/register?name=#{hc_invite.name}&email=#{hc_invite.email}&trade=#{hc_invite.trade_id}"
        TenderconMailer.sent_sc_invites(hc_invite.email,hc_invite.name,Trade.trade_name(hc_invite.trade_id),path,decline_path,session[:user_logged_id]).deliver_now
      end
      HcInvite.where(:email => nil).delete_all
      @data = render :partial => 'hc_invites/savvy'
    end
  end

  def search_by_trade
    @trade_id = params[:trade_id]
    if params[:tender_id].present?
      @tender = Tender.find(params[:tender_id])
      @all_trades = Trade.all
      puts "TEST"
    else
      @tender = nil
      @trades = Trade.all
      puts "TEST1"
    end


    if @tender.present?
      @tender_trades = TenderTrade.where(:tender_id => @tender.id)
      @trade_array = []
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trade_array << t.trade_id
        end
      end
      @trades = Trade.where(:id => @trade_array)
    else
      @trades = Trade.all
    end

    if @trade_id.to_i > 0
      @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil,:trade_id => @trade_id)
    else
      @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil)
    end

    @data = render :partial => 'hc_invites/savvy'
  end

  def remove_savvy
    hc_invite = HcInvite.find(params[:id])

    if hc_invite.present?
      HcInvite.where(:id => hc_invite.id).update_all(:status => 'remove')
      @trades = Trade.all
      @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil)
      @data = render :partial => 'hc_invites/savvy'
    end
  end

  def resent_invite
    hc_invite = HcInvite.find(params[:id])

    @trades = Trade.all
    @hc_invites = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil)
    decline_path = "http://"+request.host_with_port+"/invites/decline_tender_invite?&email=#{hc_invite.email}&trade=#{hc_invite.trade_id}"
    path = "http://"+request.host_with_port+"/users/register?name=#{hc_invite.name}&email=#{hc_invite.email}&trade=#{hc_invite.trade_id}"
    TenderconMailer.sent_sc_invites(hc_invite.email,hc_invite.name,Trade.trade_name(hc_invite.trade_id),path,decline_path).deliver_now
    @data = render :partial => 'hc_invites/savvy'
  end

  private

  def hc_invites_permitted_params
    params.permit(:name,:company,:email,:trade_id,:hc_id)
  end

end