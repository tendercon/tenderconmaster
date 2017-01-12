class HomeController < ApplicationController
  before_filter :is_logged?, except: [:index]
  layout 'home_layout', :on => [:index]
  layout 'coming_soon_layout', :on => [:coming_soon]
  skip_before_action :verify_authenticity_token
  def index

  end

  def coming_soon

  end

  def notify_tendercon
    email = params[:email];
    TenderconMailer.delay.home_notifcation('New Notification','info@tendercon.com',email)
    render :json => { :state => 'valid'}
  end
end