class AddColumnsToFeaturePages < ActiveRecord::Migration
  def change
    add_column(:feature_pages, :frequently_block_heading, :text)
    add_column(:feature_pages, :faq1, :text)
    add_column(:feature_pages, :faq2, :text)
    add_column(:feature_pages, :faq3, :text)
    add_column(:feature_pages, :faq4, :text)
    add_column(:feature_pages, :faq5, :text)
    add_column(:feature_pages, :faq6, :text)
    add_column(:feature_pages, :faq7, :text)
    add_column(:feature_pages, :faq8, :text)

    add_column(:feature_pages, :faq_ans1, :text)
    add_column(:feature_pages, :faq_ans2, :text)
    add_column(:feature_pages, :faq_ans3, :text)
    add_column(:feature_pages, :faq_ans4, :text)
    add_column(:feature_pages, :faq_ans5, :text)
    add_column(:feature_pages, :faq_ans6, :text)
    add_column(:feature_pages, :faq_ans7, :text)
    add_column(:feature_pages, :faq_ans8, :text)
  end
end
