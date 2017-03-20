class CompanyPage < ActiveRecord::Base

  validates_presence_of :headline
  validates_presence_of :intro
  validates_presence_of :team_block
  validates_presence_of :block_heading
  validates_presence_of :block_intro
  validates_presence_of :ceo_name
  validates_presence_of :ceo_title
  validates_presence_of :ceo_linkedin
  validates_presence_of :ceo_instagram
  validates_presence_of :co_founder_name
  validates_presence_of :co_founder_title
  validates_presence_of :co_founder_linkedin
  validates_presence_of :team_name3
  validates_presence_of :team_title3
  validates_presence_of :team_name4
  validates_presence_of :team_title4
  validates_presence_of :team_name5
  validates_presence_of :team_title5
  validates_presence_of :team_name6
  validates_presence_of :team_title6
  validates_presence_of :team_name7
  validates_presence_of :team_title7
  validates_presence_of :team_name8
  validates_presence_of :team_title8
  validates_presence_of :ceo_avatar
  validates_presence_of :co_founder_avatar
  validates_presence_of :team3_avatar
  validates_presence_of :team4_avatar
  validates_presence_of :team5_avatar
  validates_presence_of :team6_avatar
  validates_presence_of :team7_avatar
  validates_presence_of :team8_avatar


  has_attached_file :ceo_avatar
  validates_attachment_content_type :ceo_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :co_founder_avatar
  validates_attachment_content_type :co_founder_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team3_avatar
  validates_attachment_content_type :team3_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team4_avatar
  validates_attachment_content_type :team4_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team5_avatar
  validates_attachment_content_type :team5_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team6_avatar
  validates_attachment_content_type :team6_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team7_avatar
  validates_attachment_content_type :team7_avatar, content_type: /\Aimage\/.*\Z/
  has_attached_file :team8_avatar
  validates_attachment_content_type :team8_avatar, content_type: /\Aimage\/.*\Z/

end