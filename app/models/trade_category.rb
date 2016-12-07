class TradeCategory < ActiveRecord::Base
  has_many :trades
end