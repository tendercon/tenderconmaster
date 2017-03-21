class HeaderNav < ActiveRecord::Base
  validates_presence_of :page_type
  validates_presence_of :home
  validates_presence_of :feature
  validates_presence_of :pricing
  validates_presence_of :company
  validates_presence_of :login
  validates_presence_of :register
  validates_presence_of :logo



  has_attached_file :logo
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
end