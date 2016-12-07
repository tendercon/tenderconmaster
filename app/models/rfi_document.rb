class RfiDocument < ActiveRecord::Base
  belongs_to :user
  belongs_to :rfi

  has_attached_file :document,
                    :url  =>  ":rails_root/public/assets/rfi/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/rfi/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :document
end