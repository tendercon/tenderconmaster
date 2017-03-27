class FeaturePage < ActiveRecord::Base
  validates_presence_of :page_type
  validates_presence_of :headline
  validates_presence_of :tagline
  validates_presence_of :feature_block_1
  validates_presence_of :feature_block_2
  validates_presence_of :feature_block_3
  validates_presence_of :feature_block_4
  validates_presence_of :feature_title
  validates_presence_of :feature_desc
  validates_presence_of :feature_title2
  validates_presence_of :feature_desc2
  validates_presence_of :feature_title3
  validates_presence_of :feature_desc3
  validates_presence_of :feature_title4
  validates_presence_of :feature_desc4
  validates_presence_of :figure_holder
  validates_presence_of :figure_holder2
  validates_presence_of :figure_holder3
  validates_presence_of :figure_holder4

  validates_presence_of :frequently_block_heading
  validates_presence_of :faq1
  validates_presence_of :faq2
  validates_presence_of :faq3
  validates_presence_of :faq4
  validates_presence_of :faq5
  validates_presence_of :faq6
  validates_presence_of :faq7
  validates_presence_of :faq8
  validates_presence_of :faq_ans1
  validates_presence_of :faq_ans2
  validates_presence_of :faq_ans3
  validates_presence_of :faq_ans4
  validates_presence_of :faq_ans5
  validates_presence_of :faq_ans6
  validates_presence_of :faq_ans7
  validates_presence_of :faq_ans8





  has_attached_file :figure_holder
  validates_attachment_content_type :figure_holder, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder2
  validates_attachment_content_type :figure_holder2, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder3
  validates_attachment_content_type :figure_holder3, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder4
  validates_attachment_content_type :figure_holder4, content_type: /\Aimage\/.*\Z/
end