class TenderSitesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def delete_site
    TenderSite.where(:id => params[:id]).delete_all
    @tender_sites = TenderSite.where(:user_id => session[:user_logged_id])
    @data = render :partial => 'tenders/tender_sites/lists'
  end
end