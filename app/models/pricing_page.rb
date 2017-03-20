class PricingPage < ActiveRecord::Base

  validates_presence_of :headline
  validates_presence_of :intro
  validates_presence_of :pricing_block
  validates_presence_of :scrollto_pricing_block
  validates_presence_of :scrollto_faqs_block
  validates_presence_of :block_heading
  validates_presence_of :item_heading
  validates_presence_of :item_intro
  validates_presence_of :currency
  validates_presence_of :number
  validates_presence_of :unit
  validates_presence_of :sign_up_now
  validates_presence_of :tender_limit

  validates_presence_of :item_heading2
  validates_presence_of :item_intro2
  validates_presence_of :currency2
  validates_presence_of :number2
  validates_presence_of :unit2
  validates_presence_of :sign_up_now2
  validates_presence_of :tender_limit2

  validates_presence_of :item_heading3
  validates_presence_of :item_intro3
  validates_presence_of :currency3
  validates_presence_of :number3
  validates_presence_of :unit3
  validates_presence_of :sign_up_now3
  validates_presence_of :tender_limit3

  validates_presence_of :frequently_block_heading



end