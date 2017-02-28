class Rfi < ActiveRecord::Base
  has_many :rfi_documents
  has_many :rfi_notifications
  belongs_to :user

  def self.rfi_count(tender_id, user_id=nil)
    if user_id.present?
      self.where(:tender_id => tender_id,:user_id => user_id).count()
    else
      self.where(:tender_id => tender_id).count()
    end

  end

end