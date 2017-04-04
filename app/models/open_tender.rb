class OpenTender < ActiveRecord::Base
  belongs_to :tender
  belongs_to :user

  def self.add_new_subcontractors(users)

    tenders = Tender.where(:publish => true)
    tender_ids = []
    user_ids = []
    if tenders.present?
      tenders.each do |tender|
        tender_ids << tender.id
      end
    end

    Rails.logger.info "tender_ids ===> #{tender_ids.inspect}"
    if tender_ids.present?
      tender_ids.uniq.each do |tender|
        if users.present?
          users.each do |u|
            user = User.find(u)
            open = where(:tender_id => tender, :user_id => u).first
            Rails.logger.info "OPEN TENDERS =========> #{open.inspect}"
            unless open.present?
              open_tender = self.new
              open_tender.user_id = u
              open_tender.tender_id = tender
              reques_quote = TenderRequestQuote.where(:tender_id => tender, :sc_id => u).first
              tender_approved = TenderApprovedTrade.where(:tender_id => tender, :sc_id => u).first
              unless reques_quote.present? && tender_approved.present?
                tender_invites = TenderInvite.where(:tender_id => tender, :email => user.email)

                if tender_invites.present?
                  statuses = []
                  tender_invites.each do |ti|
                    statuses << ti.status
                  end

                  if statuses.uniq.include?('accepted')
                     # Do nothing
                  else
                    if statuses.uniq.size == 1
                      #puts "statuses ======> #{statuses.uniq.inspect} ===========> #{statuses[0]}"
                      if statuses[0] == 'rejected'
                        #if user.address.present?
                        #  if user.address.state.present?
                            #publish_tender = Tender.find(tender)
                            #if user.address.state == publish_tender.state
                              open_tender.save
                            #end
                        #  end
                        #end
                      end
                    end
                  end
                else
                  puts "NOT ON INVITES"
                  #if user.address.present?
                  #  if user.address.state.present?
                  #     publish_tender = Tender.find(tender)
                  #     if user.address.state == publish_tender.state
                         open_tender.save
                  #     end
                  #  end
                  #end

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