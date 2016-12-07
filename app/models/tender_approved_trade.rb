class TenderApprovedTrade < ActiveRecord::Base
  belongs_to :tender
  belongs_to :trade
  has_many :trades
end