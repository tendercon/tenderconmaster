class SitesController < ApplicationController

  #before_filter :is_logged?, :add_to_open_tender,  :except => [:index,:new,:create,:edit,:update,:destroy]

  #skip_before_action :verify_authenticity_token
  #layout 'application'


  def index
    @sites = Site.all
  end

  def new
    @site = Site.new

    @save_site = Site.last

  end

  def create
    @site = Site.new(sites_permitted_params)

    if @site.save
      redirect_to sites_path
    else
      render :new
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update(sites_permitted_params)
      redirect_to sites_path
    else
      render :edit
    end
  end

  def show

  end

  def get_site
    @site = Site.find(params[:id])
  end

  private

  def sites_permitted_params
    params.require(:site).permit(:id,:page_type,:header_headline,:header_tagline,:section_title,:section_intro,:item_title,:item_desc,
                                   :item_title1,:item_desc1,:item_title2,:item_desc2,:section_image1,
                                   :section_image2,:section_image3,:item_image1,:item_image2,:item_image3,
                                   :key_feature_image1)
  end


end
