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
     trade = where(:id => id).first

     if trade.present?
       trade.name
     else
       nil
     end

  end


  def self.trade_per_category(category_id)
    self.where(:trade_category_id => category_id).order('id asc')
  end

end