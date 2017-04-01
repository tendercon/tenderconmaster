class Site < ActiveRecord::Base

  validates_presence_of :page_type
  validates_presence_of :header_headline
  validates_presence_of :header_tagline
  validates_presence_of :section_title
  validates_presence_of :section_intro
  validates_presence_of :item_title
  validates_presence_of :item_desc
  validates_presence_of :item_title1
  validates_presence_of :item_desc1
  validates_presence_of :item_title2
  validates_presence_of :item_desc2
  validates_presence_of :section_image1
  # validates_presence_of :section_image2
  # validates_presence_of :section_image3
  validates_presence_of :item_image1
  validates_presence_of :item_image2
  validates_presence_of :item_image3

  validates_presence_of :section_title_trusted_by_smart
  validates_presence_of :section_intro_trusted_by_smart
  validates_presence_of :quote_intro
  validates_presence_of :quote_name
  validates_presence_of :quote_title
  validates_presence_of :quote_intro2
  validates_presence_of :quote_name2
  validates_presence_of :quote_title2
  validates_presence_of :quote_profile
  validates_presence_of :quote_profile2
  validates_presence_of :product_header

  has_attached_file :section_image1
  validates_attachment_content_type :section_image1, content_type: /\Aimage\/.*\Z/
  has_attached_file :section_image2
  validates_attachment_content_type :section_image2, content_type: /\Aimage\/.*\Z/
  has_attached_file :section_image3
  validates_attachment_content_type :section_image3, content_type: /\Aimage\/.*\Z/
  has_attached_file :item_image1
  validates_attachment_content_type :item_image1, content_type: /\Aimage\/.*\Z/
  has_attached_file :item_image2
  validates_attachment_content_type :item_image2, content_type: /\Aimage\/.*\Z/
  has_attached_file :item_image3
  validates_attachment_content_type :item_image3, content_type: /\Aimage\/.*\Z/
  has_attached_file :key_feature_image1
  validates_attachment_content_type :key_feature_image1, content_type: /\Aimage\/.*\Z/
  has_attached_file :quote_profile
  validates_attachment_content_type :quote_profile, content_type: /\Aimage\/.*\Z/
  has_attached_file :quote_profile2
  validates_attachment_content_type :quote_profile2, content_type: /\Aimage\/.*\Z/
  has_attached_file :product_image1
  validates_attachment_content_type :product_image1, content_type: /\Aimage\/.*\Z/
  has_attached_file :product_image2
  validates_attachment_content_type :product_image2, content_type: /\Aimage\/.*\Z/
  has_attached_file :product_image3
  validates_attachment_content_type :product_image3, content_type: /\Aimage\/.*\Z/
  has_attached_file :product_image4
  validates_attachment_content_type :product_image4, content_type: /\Aimage\/.*\Z/

end
