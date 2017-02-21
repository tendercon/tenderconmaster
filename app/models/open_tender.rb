class OpenTender < ActiveRecord::Base
  belongs_to :tender
  belongs_to :user

  def self.add_new_subcontractors(users)

    tenders = self.all
    tender_ids = []
    user_ids = []
    if tenders.present?
      tenders.each do |tender|
        tender_ids << tender.tender_id
        user_ids << tender.user_id
      end
    end

    if tender_ids.present?
      tender_ids.uniq.each do |tender|
        if users.present?
          users.each do |u|
            open = where(:tender_id => tender, :user_id => u).first

            unless open.present?
              open_tender = self.new
              open_tender.user_id = u
              open_tender.tender_id = tender

              reques_quote = TenderRequestQuote.where(:tender_id => tender, :sc_id => u).first
              tender_approved = TenderApprovedTrade.where(:tender_id => tender, :sc_id => u).first
              unless reques_quote.present? || tender_approved.present?
                open_tender.save
              end

            end
          end
        end

      end
    end
  end
end