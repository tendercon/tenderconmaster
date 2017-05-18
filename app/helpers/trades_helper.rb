module TradesHelper

  def category_id trade_id
    trade = Trade.find(trade_id)

    trade.trade_category_id
  end
end