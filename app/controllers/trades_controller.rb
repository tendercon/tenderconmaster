class TradesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @trades = Trade.all
  end

  def new
   @trade = Trade.new
  end

  def create
    @trade = Trade.new(trade_permitted_params)

    if @trade.save
      redirect_to trades_path
    else
      render :new
    end
  end

  def edit
    @trade = Trade.find(params[:id])
  end

  def update
    @trade = Trade.find(params[:id])
    if @trade.update(trade_permitted_params)
      redirect_to trades_path
    else
      render :edit
    end
  end

  def delete
    @trade = Trade.find(params[:id])

    @trade.destroy
    redirect_to trades_path
  end

  def get_all_lists
    name = params[:name]
    @trade = Trade.new
    @trade.name = name

    if @trade.save
      @trades = Trade.all
      @data = render :partial => 'trades/all_trades'
    else
      render :json => { :state => 'invalid'}
    end

  end

  def delete_trades
    Trade.where(:id => params[:id]).delete_all
    @hc_trades = Trade.where(:user_id => session[:user_logged_id],:status => 'new')
    @data = render :partial => 'trades/new_trade'
  end

  def new_trade

    new_inserted_trade = params[:trade]

    upper_case = new_inserted_trade.strip.upcase
    lower_case = new_inserted_trade.strip.downcase
    upcase_first_letter = new_inserted_trade.strip.titleize

    trade = Trade.where("name ='#{upper_case}' OR name = '#{lower_case}' OR name = '#{upcase_first_letter}'").first
    @trade_names = []
    @trades = Trade.all
    if @trades.present?
      @trades.each do |t|
        @trade_names << t.name
      end
    end

    if trade.present?
      render :json => { :state => 'invalid',:categories => trade.trade_category. present? ? trade.trade_category.title : nil,:id => trade.id}
    else
      # new_trade = Trade.new
      # new_trade.name = new_inserted_trade
      # new_trade.save
      new_trade = Trade.new
      new_trade.name = new_inserted_trade
      new_trade.trade_category_id = 5
      new_trade.status = 'new'
      new_trade.user_id = session[:user_logged_id]
      new_trade.save

      @hc_trades = Trade.where(:user_id => session[:user_logged_id],:status => 'new')
      @id = (params[:id]).to_i + 1
      puts "ID:#{@id}"
      @data = render :partial => 'trades/new_trade'
    end
  end


  private

  def trade_permitted_params
    params.require(:trade).permit(:id,:name)
  end
end