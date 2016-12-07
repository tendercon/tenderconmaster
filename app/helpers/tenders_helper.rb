module TendersHelper

  def get_all_unzip_files id,user_id

    folder =  Rails.root + "public/assets/tender/document/#{id}/original/"
    dir = Dir.glob("#{folder}/**/*")

    if dir.present?
      dir.each do |d|

        file = File.basename(d)
        ext = File.extname(d)
        size = File.size(d)

        if ext != '.zip' && ext.present?
          unzip = UnzipFile.new
          unzip.path = d
          unzip.user_id = user_id
          unzip.file_size = size
          unzip.filename = file
          unzip.extension = ext
          path = File.dirname(d)
          base = File.basename(path)

          if base.to_s != 'original'
            unzip.directory = base
          end

          unzip.save
        end
      end
    end

    @unzip = UnzipFile.where(:user_id => user_id)
    return @unzip
  else
    nil
  end

  def check_if_have_revision category_name,tender_id
    unzip = UnzipFile.where(:tender_id => tender_id,:directory => category_name)

    if unzip.present?
      revise_array = []
      unzip.each do |u|
        if u.revision.present?
          revise_array << u.revision
        end
      end
      ary = revise_array.reject { |c| c.present? ?  c.empty? : nil }
      if ary.present? && ary.size > 0
        true
      else
        false
      end
    else
      documents = TenderDocument.where(:tender_id => tender_id,:directory => category_name)

      if documents.present?
        revise_array = []
        documents.each do |u|
          if u.revision.present?
            revise_array << u.revision
          end
        end
        ary = revise_array.reject { |c| c.present? ?  c.empty? : nil }
        if ary.present? && ary.size > 0
          true
        else
          false
        end
      end
    end
  end

  def get_file_directory id
    document = TenderDocument.where(:id => id).first
    document.directory
  end


  def document_list directory,tender_id

      documents = TenderDocument.where(:directory => directory,:tender_id => tender_id)

      if documents.present?
        documents
      else
        unzip = UnzipFile.where(:directory => directory,:tender_id => tender_id)
        if unzip.present?
          unzip
        end
      end

  end


  def document_list_search directory,search,tender_id
    documents = TenderDocument.where("(document_file_name LIKE '%#{search}%' OR directory LIKE '%#{search}%') and tender_id = #{ tender_id}")

    if documents.present?
      documents
    else
      # unzip = UnzipFile.where("filename LIKE '%#{search}%' and directory = '#{directory}' and tender_id = #{ tender_id}")
      # if unzip.present?
      #   unzip
      # end
    end
  end

  def get_tender_trade_request quote_id

    trade_quotes = TenderRequestTrade.where(:tender_request_quote_id => quote_id)
    if trade_quotes.present?
      trade_quotes
    else
      nil
    end
  end

  def get_sc_trade_approved tender_id,sc_id
    trade_approved = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => sc_id,:status => 'approved')

    if trade_approved.present?
      trade_approved
    else
      nil
    end
  end

  def get_sc_trade_declined tender_id,sc_id
    trade_approved = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => sc_id,:status => 'declined')

    if trade_approved.present?
      trade_approved
    else
      nil
    end
  end



  def get_tender_trade_approved tender_id,sc_id,hc_id

    trade_approved = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => sc_id,:hc_id => hc_id)

    if trade_approved.present?
      trade_approved
    else
      nil
    end
  end

  def get_tender_approved tender_id,sc_id
    trade_approved = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => sc_id)

    if trade_approved.present?
      true
    else
      false
    end
  end


  def get_approved_trade request_quote_id,trade_id,tender_id
    request_quote = TenderRequestQuote.find(request_quote_id)

    if request_quote.present?
      tender_approved_trade = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => request_quote.sc_id,:hc_id => request_quote.hc_id,:trade_id => trade_id).first

      if tender_approved_trade.present?
        true
      else
        false
      end
    else
      false
    end
  end

  def get_categoty_name id
    category = Category.find(id)

    if category.present?
      category.name
    end
  end

  def get_value_name id

    t = TenderValue.find(id)

    if t.present?
      t.range
    end
  end

  def get_trade_name id

    t = Trade.find(id)

    if t.present?
      t.name
    end
  end

  def check_if_categories_has_trade tender_id,cat_id
    tender_trades = TenderTrade.where(:tender_id => tender_id)
    ids = []
    if tender_trades.present?
      tender_trades.each do |a|
        trade = Trade.find(a.trade_id)
        if trade.trade_category_id.to_i == cat_id.to_i
          ids << trade.id
        end
      end
    end

    if ids.present?
      true
    else
      false
    end
  end


  def return_table_data document_id
    a = "<td>#{document_id}</td>".html_safe
  end

  def get_request_status id
    tender_request_quote = TenderRequestQuote.where(:id => id).first

    if tender_request_quote.status == 'approved'
      "Approved"
    elsif tender_request_quote.status == 'declined'
      "Declined"
    end
  end

  def get_invite_company_name email

    t = User.where(:email => email).first

    if t.present?
      t.company
    else
      email
    end
  end

  def get_tender_due id

    t = TenderQuote.where(:tender_id => id).first
    if t.present?
      t.quote_date.to_datetime.strftime("%d.%m.%Y %H:%M %p")
    end
    # if t.present?
    #   if t.quote_date.present?
    #    "#{t.quote_date[3..4]}.#{t.quote_date[0..1]}.#{t.quote_date[6..9]} #{t.quote_date[11..20]}"
    #   else
    #     nil
    #   end
    # end
  end

  def get_tender_site_dates id

    t = TenderSite.where(:id => id).first
    if t.present?
      t.site_date.to_datetime.strftime("%d.%m.%Y %H:%M %p")
    end
    # if t.present?
    #   if t.quote_date.present?
    #    "#{t.quote_date[3..4]}.#{t.quote_date[0..1]}.#{t.quote_date[6..9]} #{t.quote_date[11..20]}"
    #   else
    #     nil
    #   end
    # end
  end



  def get_tender_sites id
    sites = TenderSite.where(:tender_id => id)

    if sites.present?
      sites
    else
      nil
    end
  end

  def get_tender_trades id
    trades = TenderTrade.where(:tender_id => id)

    if trades.present?
      trades
    else
      nil
    end
  end

  def get_tender_trade_status

  end

  def check_tender_trade_per_sc tender_id,sc_id,trade_id
    tender_approved = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => sc_id,:trade_id => trade_id).first

    if tender_approved.present?
      true
    else
      false
    end
  end

  def get_trade_category id

    trade = Trade.find(id)

    if trade.present?
      t = TradeCategory.find(trade.trade_category_id)
      if t.present?
        t.title
      else
        nil
      end
    end
  end

  def get_trade_category_id id
    trade = Trade.find(id)

    if trade.present?
      trade.trade_category_id
    end
  end

  def get_trade_category_name trade_category_id
    t = Category.find(trade_category_id)
    if t.present?
      t.name
    else
      nil
    end
  end

  def convert_kb_to_mb size

    mb = size.to_f / 1024 / 1024

    (mb.to_f).round(3)
  end

  def get_distance tender_id,user_id
    user = User.find(user_id)
    if user.address.present?
      if user.address.location.present?
        user_address = Geocoder.coordinates(user.address.location)
        current_location =  Geokit::LatLng.new(user_address[0],user_address[1])
        tender = Tender.find(tender_id)

        if tender.address.present?
          tender_location = Geocoder.coordinates(tender.address)

          destination = "#{tender_location[0]},#{tender_location[1]}"
          distance = current_location.distance_to(destination)/1.61
          return "#{distance.to_i} KM"
        else
          nil
        end
      else
        nil
      end

    else
      nil
    end
  end


  def get_trade_list_from_package trade_category_id,tender_id
    t = TenderPackage.where(:category_id => trade_category_id, :tender_id => tender_id)

    if t.present?
      t
    end
  end

  def get_tender_document_package tender_id
    document_packages = DocumentPackage.where(:tender_id => tender_id)
    document_packages
  end

  def get_count_tender_request user_id,tender_id
    tender_request = TenderRequestQuote.where(:hc_id =>  user_id,:tender_id => tender_id).count()

    if tender_request > 0
      tender_request
    else
      0
    end
  end

  def get_invitation_count tender_id
    TenderInvite.where("tender_id = #{tender_id} and email_sent is not null").count()
  end

  def get_invitation_open_count tender_id
    TenderInvite.where("tender_id = #{tender_id} and tender_open_date is not null").count()
  end

  def get_invitation_accepted_count tender_id
    TenderInvite.where("tender_id = #{tender_id} and tender_acceptance_date is not null").count()
  end

  def get_quote_submitted_count tender_id
    #TenderInvite.where("tender_id = #{tender_id} and status = 'accepted'").count()
    0
  end

  def get_request_count tender_id
    TenderRequestQuote.where("tender_id = #{tender_id} and approved_date is null and status is null").count()
  end

  def get_request_approved tender_id
    TenderRequestQuote.where("tender_id = #{tender_id} and approved_date is not null and status = 'approved'").count()
  end

  def get_request_declined tender_id
    TenderRequestQuote.where("tender_id = #{tender_id} and declined_date is not null and status = 'declined'").count()
  end

  def get_trade_count tender_id
    trades = TenderRequestQuote.where("tender_id = #{tender_id} and declined_date is null")
    puts "TRADES---------> #{trades.inspect}"
    trade_count = []
    if trades.present?
      trades.each do |a|
        trade_count << a.trade_id
      end

      trade_count.uniq.size
    else
      0
    end
  end

  def get_subcontractors_count tender_id
    subs = TenderRequestQuote.where("tender_id = #{tender_id} and declined_date is  null and status != 'declined'")
    sub_count = []
    if subs.present?
      subs.each do |a|
        sub_count << a.sc_id
      end

      sub_count.uniq.size
    else
      0
    end
  end

  def get_packages_count tender_id
    TenderPackage.where(:tender_id => tender_id).count()
  end

  def get_tender_request tender_id,sc_id
    tender_request = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => sc_id)

    if tender_request.present?
      tender_request
    else
      nil
    end
  end

  def get_tender_invite_status tender_id,sc_id
    invites = TenderInvite.where(:tender_id => tender_id,:user_id => sc_id).where("status != 'accepted'")

    if invites.present?
      invites
    else
      nil
    end
  end

  def replace_char_to_string str
    replacement_rules = {
        '/' => '_',
        ' ' => '_'
    }
    matcher = /#{replacement_rules.keys.join('|')}/

    str.gsub(matcher, replacement_rules)
  end

  def get_document_package document_id,tender_id
    tender_id = tender_id
    document_id  = document_id

    tender_package = TenderPackage.where(:tender_id => tender_id)

    if tender_package.present?

      packages = Package.where(:tender_id => tender_id)
      docs = []
      if packages.present?
        packages.each do |p|
          if p.code.include? "#{document_id}"
            docs << p.id
          end
        end

        if docs.present?
          docs.size
        else
          0
        end
      end
    else
       0
    end
  end

  def check_if_has_documents tender_id
    docs = TenderDocument.where("tender_id = #{tender_id} and directory !='unzip'")
    zip = UnzipFile.where("tender_id = #{tender_id}")

    if docs.present? || zip.present?
      true
    else
      false
    end
  end

  def get_sc_id quote_id
    request_quote = TenderRequestQuote.find(quote_id)

    if request_quote.present?
      request_quote.sc_id
    else
      nil
    end
  end

  def get_sc_tender_trade quote_id
    request_quote = TenderRequestQuote.where(quote_id).first

    if request_quote.present?
      tender_trade = TenderRequestTrade.where(:tender_request_quote_id => quote_id).first
      puts "sdjdhajdhja---------> #{tender_trade.inspect}"
      if tender_trade.present?
        tender_trade
      end

    else
      nil
    end
  end

  def get_tender_title id
    tender = Tender.where(:id => id).first
    if tender.present?
      tender.title
    else
      nil
    end
  end

  def get_open_tender_trades tender_id,user_id
    open_trades = OpenTenderTrade.where(:tender_id => tender_id,:user_id => user_id)
    trades = []
    if open_trades.present?
      open_trades.each do |a|
        trades << a.trade_id
      end
      puts "trades.uniq------------>#{trades.uniq}"
      return trades.uniq

    else
      nil
    end
  end


  def get_sc_user trade_id,tender_id
    request_quote_array = []
    request_quote = TenderRequestQuote.where(:tender_id => tender_id)

    if request_quote.present?
      request_quote.each do |r|
        request_quote_array << r.id
      end
    end
    users = []
    if request_quote_array.present?
      request_quote_array.each do |a|
        request_trade = TenderRequestTrade.where(:tender_request_quote_id => a, :trade_id => trade_id)

        if request_trade.present?
          request_trade.each do |f|
            request = TenderRequestQuote.find(f.tender_request_quote_id)
            users <<  request.sc_id
          end
        end
      end

      if users.present?
        users
      else
        nil
      end
    else
      nil
    end
  end

  def get_invites_per_trade trade_id,tender_id
    invites = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id)

    if invites.present?
      invites
    else
      nil
    end
  end

  def get_user_tender_per_email email
    user = User.where(:email => email).first

    if user.present?
      "#{user.first_name} #{user.last_name}"
    else
      nil
    end
  end

  def get_sc_invite trade_id,tender_id
    invites = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id)
    ids = []
    emails = []
    if invites.present?
      invites.each do |i|
        user = User.where(:email => i.email).first
        if user.present?
          ids << user.id
        else
          emails << i.email
        end
      end
    end

    user_array = []
    if ids.present?
      users = User.where(:id => ids)
      users.each do |a|
        user_array << a.id
      end

      if emails.present?
        user_array.concat(emails)
      end
      return user_array
    else
      return emails
    end
  end



  def get_invited_trade tender_id,email

    invites = TenderInvite.where(:tender_id => tender_id,:email => email)
    trades = []
    if invites.present?
      invites.each do |a|
        trades << a.trade_id
      end

      if trades.present?
        return trades.uniq
      else
        return nil
      end

    else
      return nil
    end

  end

  def check_if_trade_contains trade_id,tender_id,search
    tender_invite = TenderInvite.where("tender_id = #{tender_id} and trade_id = #{trade_id} and (name LIKE '%#{@search}%' OR email LIKE '%#{@search}%')")
    request_quote = TenderRequestQuote.where(:tender_id => tender_id)
    request_quote_array = []
    if request_quote.present?
      request_quote.each do |r|
        request_quote_array << r.id
      end
    end
    users = []
    if request_quote_array.present?
      request_quote_array.each do |a|
        request_trade = TenderRequestTrade.where(:tender_request_quote_id => a, :trade_id => trade_id)


        if request_trade.present?
          request_trade.each do |f|
            request = TenderRequestQuote.find(f.tender_request_quote_id)
            users <<  request.sc_id
          end
        end
      end

      if users.present?
        user_search = User.where(:id => users).where("company LIKE '%#{@search}%'")

        if user_search.present?
          return true
        end

      else
        if tender_invite.present?
          return true
        else
          return false
        end
      end
    else
      if tender_invite.present?
        return true
      else
        return false
      end
    end


  end

  def get_approved_trade_status trade_id,tender_id,sc_id
    tender_approved = TenderApprovedTrade.where(:trade_id => trade_id,:tender_id => tender_id,:sc_id => sc_id).first

    if tender_approved.present?
      tender_approved.status
    else
      nil
    end

  end

  def get_invite_status tender_id,trade_id,user_id
    if user_id.to_i > 0
      user = User.find(user_id)
      invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => user.email).first
    else
      invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => user_id).first
    end

    if invite.present?
      invite.status
    else
      nil
    end
  end

  def return_trade_per_status status,tender_id,trade_id,user_id=nil
     if status == 'invited'
       invites = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id)

       if invites.present?
         ids = []
         emails = []
         invites.each do |i|
           user = User.where(:email => i.email).first
           if user.present?
             ids << user.id
           else
             emails << i.email
           end
         end

         user_array = []
         if ids.present?
           users = User.where(:id => ids)
           users.each do |a|
             user_array << a.id
           end

           if emails.present?
             user_array.concat(emails)
           end
           return user_array
         else
           return emails
         end
       end
     elsif status == 'requesting'
       tender_requesting = TenderRequestQuote.where(:tender_id => tender_id,:hc_id => user_id)
       ids = []
       if tender_requesting.present?
         tender_requesting.each do |i|
           ids << i.id
         end

         if ids.present?
           request_to_quote = TenderRequestTrade.where(:tender_request_quote_id => ids,:trade_id => trade_id)
           request = []

           if request_to_quote.present?
             request_to_quote.each do |a|
               request << a.tender_request_quote_id
             end

             if request.present?
               approved = TenderApprovedTrade.where(:tender_request_quote_id => request)

               new_ids = []

               if approved.present?
                 approved.each do |a|
                   new_ids << a.tender_request_quote_id
                 end
               end

               requesting_ids = []
               if ids.present?
                 ids.each_with_index do |i,index|
                    if !new_ids.include? i
                      requesting_ids << i
                    end
                 end
               end

               if requesting_ids.present?
                 users = []
                 if requesting_ids.present?
                   requesting_ids.each do |a|
                     request_trade = TenderRequestTrade.where(:tender_request_quote_id => a, :trade_id => trade_id)

                     if request_trade.present?
                       request_trade.each do |f|
                         request = TenderRequestQuote.find(f.tender_request_quote_id)
                         users <<  request.sc_id
                       end
                     end
                   end

                   if users.present?
                     users
                   else
                     nil
                   end
                 else
                   nil
                 end
               end
             end
           end
         end
       end
     elsif status == 'declined'
       tender_requesting = TenderRequestQuote.where(:tender_id => tender_id,:hc_id => user_id)
       ids = []
       if tender_requesting.present?
         tender_requesting.each do |i|
           ids << i.id
         end

         if ids.present?
           request_to_quote = TenderRequestTrade.where(:tender_request_quote_id => ids,:trade_id => trade_id)
           request = []

           if request_to_quote.present?
             request_to_quote.each do |a|
               request << a.tender_request_quote_id
             end

             if request.present?
               approved = TenderApprovedTrade.where(:tender_request_quote_id => request,:status => 'declined')

               new_ids = []

               if approved.present?
                 approved.each do |a|
                   new_ids << a.tender_request_quote_id
                 end
               end

               requesting_ids = []
               if ids.present?
                 ids.each_with_index do |i,index|
                   if new_ids.include? i
                     requesting_ids << i
                   end
                 end
               end

               if requesting_ids.present?

                 users = []
                 if requesting_ids.present?
                   requesting_ids.each do |a|
                     request_trade = TenderRequestTrade.where(:tender_request_quote_id => a, :trade_id => trade_id)

                     if request_trade.present?
                       request_trade.each do |f|
                         request = TenderRequestQuote.find(f.tender_request_quote_id)
                         users <<  request.sc_id
                       end
                     end
                   end

                   if users.present?
                     users
                   else
                     nil
                   end
                 else
                   nil
                 end
               end
             end
           end
         end
       end
     elsif status == 'tendering'
       tender_requesting = TenderRequestQuote.where(:tender_id => tender_id,:hc_id => user_id)
       ids = []
       if tender_requesting.present?
         tender_requesting.each do |i|
           ids << i.id
         end

         if ids.present?
           request_to_quote = TenderRequestTrade.where(:tender_request_quote_id => ids,:trade_id => trade_id)
           request = []

           if request_to_quote.present?
             request_to_quote.each do |a|
               request << a.tender_request_quote_id
             end

             if request.present?
               approved = TenderApprovedTrade.where(:tender_request_quote_id => request,:status => 'approved')

               new_ids = []

               if approved.present?
                 approved.each do |a|
                   new_ids << a.tender_request_quote_id
                 end
               end

               requesting_ids = []
               if ids.present?
                 ids.each_with_index do |i,index|
                   if new_ids.include? i
                     requesting_ids << i
                   end
                 end
               end

               if requesting_ids.present?
                 users = []
                 if requesting_ids.present?
                   requesting_ids.each do |a|
                     request_trade = TenderRequestTrade.where(:tender_request_quote_id => a, :trade_id => trade_id)
                     if request_trade.present?
                       request_trade.each do |f|
                         request = TenderRequestQuote.find(f.tender_request_quote_id)
                         users <<  request.sc_id
                       end
                     end
                   end

                   if users.present?
                     users
                   else
                     nil
                   end
                 else
                   nil
                 end
               end
             end
           end
         end
       end
     end
  end

  def return_pending_cnt arr
    request = TenderRequestTrade.where(:tender_request_quote_id => arr).count()

    if request.present?
      request
    else
      0
    end
  end

  def return_trade_sc_pending trade_id,tender_id
    request = TenderRequestQuote.where(:tender_id => tender_id)
    users = []
    if request.present?
      request.each do |r|
        trades = TenderRequestTrade.where(:tender_request_quote_id => r.id,:trade_id => trade_id)

        if trades.present?
          trades.each do |t|
            users << t.tender_request_quote_id
          end
        end
      end
    end

    if users.present?
      users.size
    else
      0
    end
  end

  def get_approved_trade_count trade_id,tender_id
    TenderApprovedTrade.where(:tender_id => tender_id,:trade_id => trade_id).count()
  end

  def return_trade_pending_invites  trade_id,tender_id
    tender_invites = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:status => nil).count()

    if tender_invites.present?
      tender_invites
    else
      0
    end
  end

  def get_tender_invites tender_id,trade_id,user_id
    user = User.where(:id => user_id).first
    if user.present?
      email = user.email
      tender_invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => email).first
    else
      tender_invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id).first
    end
    tender_invite
  end

  def return_package_cnt tender_id
    @package_count = TenderPackage.where(:tender_id => tender_id).count()
    return @package_count
  end

  def return_download_package_cnt tender_id,trade_id
    download = PackageDownload.where(:tender_id => tender_id,:trade_id => trade_id).count()

    if download.present?
      download
    else
      0
    end
  end

  def check_tender_invite_status tender_id,trade_id,email
    invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => email).first
    if invite.present?
      invite.status
    else
      nil
    end
  end

  def return_package_download tender_id,user_id,trade_id
    download = PackageDownload.where(:tender_id => tender_id,:user_id => user_id,:trade_id => trade_id)
    trades = []
    if download.present?
      download.each do |a|
        trades << a.trade_id
      end
    end

    trade_download = Trade.where(:id => trades)
    return trade_download
  end

  def get_parent_directory dir
    collective_dir = dir.split("/")
    collective_dir[0]
  end

  def get_parent_next_dir dir
    collective_dir = dir.split("/")

    if collective_dir.present?
      collective_dir[collective_dir.size - 1]
    end
  end


  def return_document_lists tender_id,directory

    doc = TenderDocument.where(:tender_id => tender_id,:directory => directory)

    if doc.present?
      a =
        doc.each do |a|
          "<tr>
            <td><input type='checkbox' class='document_list' name='documents[]' value='#{a.id}'></td>
            <td>#{a.document_file_name}</td>
            <td><input type='text' id='#{a.id}' name='revision' class='revision' alt='#{a.directory}' value='#{a.revision.present? ? a.revision : nil}'></td>
            <td>#{a.document_file_size} kbs</td>
            <td>
              <i class='fa fa-check' aria-hidden='true' style='color: green'></i>
            </td>
          </tr>".html_safe
        end
    end
    return a
  end

end