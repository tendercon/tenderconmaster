class PackageDownloadsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def save_download
    tender_id = params[:tender_id]
    user_id = params[:user_id]
    trade_name = File.basename(params[:trade],File.extname(params[:trade]))

    trade = Trade.where(:name => trade_name).first
    package_download = PackageDownload.new
    package_download.tender_id = tender_id
    package_download.user_id = user_id
    package_download.trade_id = trade.id

    if package_download.save
      render :json => { :state => 'valid'}
    else
      render :json => { :state => 'invalid'}
    end

  end


  private

  def package_download_premitted_params
    params.require(:package_download).permit(:id,:user_id,:tender_id,:trade_id)
  end

end