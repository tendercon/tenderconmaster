class TenderRequestTrade < ActiveRecord::Base
  belongs_to :tender_request_quote
  belongs_to :trade
end