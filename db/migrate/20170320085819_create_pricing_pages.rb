class CreatePricingPages < ActiveRecord::Migration
  def change
    create_table :pricing_pages do |t|
      t.text  :headline
      t.text  :intro
      t.string  :pricing_block
      t.string  :scrollto_pricing_block
      t.text    :scrollto_faqs_block
      t.string  :block_heading
      t.text  :item_heading
      t.text  :item_intro
      t.text  :currency
      t.string  :number
      t.text  :unit
      t.text  :sign_up_now
      t.text  :tender_limit
      t.text  :item_heading2
      t.text  :item_intro2
      t.text  :currency2
      t.string  :number2
      t.text  :unit2
      t.text  :sign_up_now2
      t.text  :tender_limit2
      t.text  :item_heading3
      t.text  :item_intro3
      t.text  :currency3
      t.string  :number3
      t.text  :unit3
      t.text  :sign_up_now3
      t.text  :tender_limit3

      t.text  :frequently_block_heading
      t.text  :faq1
      t.text  :faq2
      t.text  :faq3
      t.text  :faq4
      t.text  :faq5
      t.text  :faq6
      t.text  :faq7
      t.text  :faq8

      t.text  :faq1_desc
      t.text  :faq2_desc
      t.text  :faq3_desc
      t.text  :faq4_desc
      t.text  :faq5_desc
      t.text  :faq6_desc
      t.text  :faq7_desc
      t.text  :faq8_desc

    end
  end
end
