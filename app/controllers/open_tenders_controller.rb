class OpenTendersController < ApplicationController

  def get_request_body
    @tender = Tender.where(:id => params[:tender_id]).first
    @trade_categories = TradeCategory.all
    @user_quote = TenderRequestQuote.where(:sc_id => session[:user_logged_id]).last
    @tender_count = Tender.all.count()
    @sectors = Category.all
    @values = TenderValue.all
    @primary_trade_array = []
    @secondary_trade_array = []
    @primary_trade = PrimaryTrade.where(:user_id => session[:user_logged_id])
    @secondary_trade = SecondaryTrade.where(:user_id => session[:user_logged_id])

    if @primary_trade.present?
      @primary_trade.each do |p|
        @primary_trade_array << p.trade_id
      end
    end

    if @secondary_trade.present?
      @secondary_trade.each do |s|
        @secondary_trade_array << s.trade_id
      end
    end

    @data = render :partial => 'open_tenders/open_tender_request'

  end

end