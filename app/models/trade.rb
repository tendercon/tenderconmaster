class Trade < ActiveRecord::Base
  belongs_to :primary_trade
  belongs_to :secondary_trade
  belongs_to :trade_category
  belongs_to :tender_approved_trade
  has_many :tender_request_trades
  has_many :package_downloads
  has_many :tender_approved_trades

  validates :name, presence: true
end