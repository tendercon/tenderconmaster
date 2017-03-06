class OpenTender < ActiveRecord::Base
  belongs_to :tender
  belongs_to :user

  def self.add_new_subcontractors(users)

    tenders = Tender.all
    tender_ids = []
    user_ids = []
    if tenders.present?
      tenders.each do |tender|
        tender_ids << tender.id
      end
    end





    if tender_ids.present?
      tender_ids.uniq.each do |tender|
        if users.present?
          users.each do |u|
            user = User.find(u)
            open = where(:tender_id => tender, :user_id => u).first


            unless open.present?
              open_tender = self.new
              open_tender.user_id = u
              open_tender.tender_id = tender
              reques_quote = TenderRequestQuote.where(:tender_id => tender, :sc_id => u).first
              tender_approved = TenderApprovedTrade.where(:tender_id => tender, :sc_id => u).first
              unless reques_quote.present? && tender_approved.present?
                tender_invites = TenderInvite.where("tender_id = #{tender} and  email='#{user.email}'")
                puts "tender_invites =======> #{tender_invites.inspect}"
                if tender_invites.present?
                  statuses = []
                  tender_invites.each do |ti|
                    statuses << ti.status
                    puts "TENDER=========> #{ti.status} =======> #{tender}"
                  end

                  if statuses.uniq.include?('accepted')
                     # Do nothing
                  else
                    if statuses.uniq.size == 1
                      puts "statuses ======> #{statuses.uniq.inspect} ===========> #{statuses[0]}"
                      if statuses[0] == 'rejected'

                        open_tender.save
                      end

                    end

                  end
                else
                  open_tender.save
                end


              end

            end
          end
        end
        if users.present?
          users.each do |u|
            reques_quote = TenderRequestQuote.where(:tender_id => tender, :sc_id => u).first
            tender_approved = TenderApprovedTrade.where(:tender_id => tender, :sc_id => u).first

            if  reques_quote.present? ||  tender_approved.present?
              OpenTender.where(:tender_id => tender, :user_id => u).delete_all
            end
          end
        end

      end
    end
  end
end