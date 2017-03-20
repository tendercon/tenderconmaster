class HomeController < ApplicationController
  before_filter :is_logged?, except: [:index,:coming_soon,:get_in_touch,:notify_tendercon,:features,:pricing,:company,
                                      :blog,:contact,:terms,:policies]
  layout 'landing_page', :on => [:index]
  layout 'coming_soon_layout', :on => [:coming_soon]
  skip_before_action :verify_authenticity_token

  def index
    @site = Site.first
    render :layout => 'landing_page'

    puts "@site ========> #{@site.inspect}"
    puts "request.request_uri#{request.fullpath}"
    Rails.logger.info "request.request_uri ======> #{request.fullpath}"
    Rails.logger.info "request.original_url ======> #{request.original_url}"
  end

  def features
    render :layout => 'landing_page'
  end

  def pricing
    render :layout => 'landing_page'
  end

  def company
    render :layout => 'landing_page'
  end

  def blog
    render :layout => 'landing_page'
  end

  def contact
    render :layout => 'landing_page'
  end

  def terms
    render :layout => 'landing_page'
  end

  def policies
    render :layout => 'landing_page'
  end


  def coming_soon
    user_loc = Geocoder.search("205/414 Garderners Rd, Rosebery, NSW 2018")
    puts "user_loc ====> #{user_loc.inspect}"
  end

  def notify_tendercon
    email = params[:email];
    company = params[:company]
    name = params[:name]
    position = params[:position]
    TenderconMailer.delay.home_notifcation('New Notification','info@tendercon.com',email,company,name,position)
    render :json => { :state => 'valid'}
  end

  def get_in_touch
    name = params[:name]
    email = params[:email]
    msg  = params[:msg]
    TenderconMailer.delay.get_in_touch('Get in Touch','info@tendercon.com',email,name,msg)
    render :json => { :state => 'valid'}
  end

end