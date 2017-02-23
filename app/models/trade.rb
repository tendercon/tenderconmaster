class Trade < ActiveRecord::Base
  belongs_to :primary_trade
  belongs_to :secondary_trade
  belongs_to :trade_category
  belongs_to :tender_approved_trade
  has_many :tender_request_trades
  has_many :package_downloads
  has_many :tender_approved_trades
  has_many :hc_invites

  validates :name, presence: true

  def self.trade_name(id)
     trade = find(id)
     trade.name
  end
end