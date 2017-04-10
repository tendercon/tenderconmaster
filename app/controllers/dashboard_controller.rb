class DashboardController < ApplicationController

  before_filter :add_to_open_tender, :only => [:index]

  def index

    if params[:newly_user].present?
      TenderconMailer.welcome_email(@user.email,@user.id,root_url).deliver_now
    end
    #TenderconMailer.sent_quotes(session[:user_logged_id],12,"Cranes","http://"+request.host_with_port+"/users/login").deliver_now
    if session[:role] == 'Head Contractor'
      @hc_invite_subs = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil).where("email != null OR email != ''")
    end

  end
end