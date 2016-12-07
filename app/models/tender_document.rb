class TenderDocument < ActiveRecord::Base
  belongs_to :user
  belongs_to :tender

  has_attached_file :document,
                    :url  =>  ":rails_root/public/assets/tender/document/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/tender/document/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :document
  #validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  #validates_attachment_size :image, :in => 0.megabytes..2.megabytes
end