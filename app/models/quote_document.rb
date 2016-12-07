class QuoteDocument < ActiveRecord::Base
  belongs_to :quote

  has_attached_file :document,
                    :url  =>  ":rails_root/public/assets/quotes/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/quotes/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :document
end