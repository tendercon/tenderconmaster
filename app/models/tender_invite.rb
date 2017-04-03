class TenderInvite < ActiveRecord::Base
  belongs_to :tender
  has_many :invited_tender_notifications


  def self.tender_invites(id,added_by = nil)
    if added_by.present?
      where("tender_id = #{id} and added_by = 'admin'").count()
    else
      where("tender_id = #{id}").count()
    end

  end

  def self.tender_opened(id)
    where("tender_id = #{id}  and tender_open_date is not null").count()
  end

  def self.tender_accepted(id)
    where("tender_id = #{id}  and tender_acceptance_date is not null and status = 'accepted'").count()
  end

end