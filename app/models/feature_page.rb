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


  has_attached_file :figure_holder
  validates_attachment_content_type :figure_holder, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder2
  validates_attachment_content_type :figure_holder2, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder3
  validates_attachment_content_type :figure_holder3, content_type: /\Aimage\/.*\Z/
  has_attached_file :figure_holder4
  validates_attachment_content_type :figure_holder4, content_type: /\Aimage\/.*\Z/
end