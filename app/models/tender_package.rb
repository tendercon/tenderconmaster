class TenderPackage < ActiveRecord::Base
  belongs_to :tender
  has_many   :tender_documents
  has_many   :tender_documents
  has_many   :categories
end