class HomeController < ApplicationController
  before_filter :is_logged?, except: [:index,:coming_soon,:get_in_touch,:notify_tendercon,:features,:pricing,:company,
                                      :blog,:contact,:terms,:policies]
  layout 'landing_page', :on => [:index]
  layout 'coming_soon_layout', :on => [:coming_soon]
  skip_before_action :verify_authenticity_token

  def index
    url = request.original_url
    if url.include?("builder")
      @site = Site.where(:page_type => "builder").first
    elsif url.include?("subcontractor")
      @site = Site.where(:page_type => "subcontractor").first
    else
      #@site = nil
      @site = Site.where(:page_type => "builder").first
    end

    render :layout => 'landing_page'
  end

  def landing_page

  end


  def features
    url = request.original_url
    if url.include?("builder")
      @feature_page = FeaturePage.where(:page_type => "builder").first
    elsif url.include?("subcontractor")
      @feature_page = FeaturePage.where(:page_type => "subcontractor").first
    else
      @feature_page = nil
    end
    render :layout => 'landing_page'
  end

  def pricing
    @pricing = PricingPage.last
    render :layout => 'landing_page'
  end

  def company
    @company_page = CompanyPage.last
    render :layout => 'landing_page'
  end

  def blog
    render :layout => 'landing_page'
  end

  def contact
    @new_contact = ContactPage.new
    @contact = ContactPage.last
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