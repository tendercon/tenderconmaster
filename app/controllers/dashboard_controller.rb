class DashboardController < ApplicationController

  before_filter :add_to_open_tender, :only => [:index]

  def index
    Rails.logger.info "EMAIL_ACCOUNT =============> #{ENV['EMAIL_ACCOUNT']}"
    Rails.logger.info "EMAIL_PASSWORD =============> #{ENV['EMAIL_PASSWORD']}"
    Rails.logger.info "INTERCOM_APP_ID =============> #{ENV['INTERCOM_APP_ID']}"
    Rails.logger.info "PUBLISHABLE_KEY =============> #{ENV['PUBLISHABLE_KEY']}"
    Rails.logger.info "SECRET_KEY =============> #{ENV['SECRET_KEY']}"
    Rails.logger.info "SECRET_KEY_BASE =============> #{ENV['SECRET_KEY_BASE']}"
    if session[:role] == 'Head Contractor'
      @hc_invite_subs = HcInvite.where(:hc_id => session[:user_logged_id],:status => nil).where("email != null OR email != ''")
    end

  end
end