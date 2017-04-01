class DashboardController < ApplicationController

  before_filter :add_to_open_tender, :only => [:index]

  def index
    if session[:role] == 'Head Contractor'
      @hc_invite_subs = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil).where("email != null OR email != ''")
      puts "@hc_invite_subs =========> #{@hc_invite_subs.inspect}"
    end

  end
end