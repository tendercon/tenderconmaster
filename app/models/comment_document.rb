class CommentDocument < ActiveRecord::Base
  belongs_to :rfi_comment

  has_attached_file :document,
                    :url  =>  ":rails_root/public/assets/comments/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/comments/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :document
end