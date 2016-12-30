class TendersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @tenders = Tender.all
  end

  def new_tender
    require 'zip'
    @user = User.find(session[:user_logged_id])
    @categories = Category.all
    @values = TenderValue.all
    @unzip_dirs = []
    @docs1 = []
    @trade_category_array = []
    @trade_categories = TradeCategory.all
    @tender_document = TenderDocument.new
    @tender_files = TenderDocument.new
    @trades = []
    @trade_names = []
    if @trades.present?
      @trades.each do |t|
        @trade_names << t.name
      end
    end

    if params[:info_id].present?
      @tender = Tender.find(params[:info_id])
      @tender_count = TenderSite.where(:tender_id => @tender.id).count()
      @tender_sites = TenderSite.where(:tender_id => @tender.id)
      @tender_trades = TenderTrade.where(:tender_id => @tender.id)
      @trade_categories = TradeCategory.all
      #@trades = TenderTrade.where(:tender_id => params[:info_id])
      @all_trades = Trade.all
      @document_packages = DocumentPackage.where(:tender_id => params[:info_id])


      @trade_array = []
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trade_array << t.trade_id
        end
      end
      @trades = Trade.where(:id => @trade_array)
      @directory_array = []
      @directory_array_1 = []
      @directory_array_2 = []
      @document_array = []
      @tender_packages = TenderPackage.where(:tender_id => params[:info_id]).order("category_id asc")
      @package_array = []
      @tender_package_header = []
      @category_array = []
      if @tender_packages.present?
        @tender_packages.each_with_index do |a,i|
          tc = TradeCategory.find(a.category_id)
          @category_array << a.category_id

          if !@package_array.include? tc.title
            @package_array << tc.title
          end
          @package_array << a.trade_id
          @directory_array_1 << a.category_id
        end
      end

      @tender_package_count = TenderPackage.where(:tender_id => params[:info_id]).count()

      @tender_package_array = []
      @tender_package_array_1 = []
      @tender_package_array_2 = []
      @trade_ids = []
      if @tender_packages.present?
        @tender_packages.each do |p|
          @trade_ids << p.trade_id
        end
      end

      @packages = Package.where(:tender_id => params[:info_id])
      @package_lists = []
      if @packages.present?
        @packages.each do |p|
          @package_lists << p.code
        end
      end

      @tender_invites = TenderInvite.where(:tender_id => params[:info_id])
      if params[:id].present?
        @documents = TenderDocument.where(:id => params[:id])
      else
        @documents = TenderDocument.where("user_id = #{session[:user_logged_id]} AND tender_id =#{params[:info_id]} AND directory != 'unzip'").order('created_at desc,directory desc')
      end


      urls = []
      @directories = []

      if @documents.present?
        @documents.each do |u|
          if u.directory != 'unzip'
            @directories << u.directory
            urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
          end
        end
      end
      @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }

      @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => params[:info_id])

      if @unzips.present?
        @unzips.each do |a|
          @new_direcotires << a.directory
        end
      end
    end
  end

  def filter_by_categories
    @tender_id = params[:tender_id]
    cat_id = params[:id]
    @vals = params[:vals]

    if @tender_id.present?
      @tender = Tender.find(@tender_id)
      @tender_trades = TenderTrade.where(:tender_id => @tender_id)
      @trade_categories = TradeCategory.all

      @trade_array = []
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trade_array << t.trade_id
        end
      end
      @directory_array = []
      @directory_array_1 = []
      @directory_array_2 = []
      @document_array = []
      @category_array = []

      if cat_id.to_i > 0
        @tender_packages = TenderPackage.where(:tender_id => @tender_id,:category_id => cat_id)
      else
        @tender_packages = TenderPackage.where(:tender_id => @tender_id).order("category_id asc")
      end

      @all_tender_packages = TenderPackage.where(:tender_id => @tender_id)

      if @all_tender_packages.present?
        @all_tender_packages.each do |v|
          @category_array << v.category_id
        end
      end

      @package_array = []
      @tender_package_header = []

      if @tender_packages.present?
        @tender_packages.each_with_index do |a,i|
          tc = TradeCategory.find(a.category_id)
          if !@package_array.include? tc.title
            @package_array << tc.title
          end
          @package_array << a.trade_id
          @directory_array_1 << a.category_id
        end
      end

      if cat_id.to_i > 0
        @tender_package_count = TenderPackage.where(:tender_id => @tender_id,:category_id =>cat_id).count()
      else
        @tender_package_count = TenderPackage.where(:tender_id => @tender_id).count()
      end

      @tender_package_array = []
      @tender_package_array_1 = []
      @tender_package_array_2 = []
      @trade_ids = []
      if @tender_packages.present?
        @tender_packages.each do |p|
          @trade_ids << p.trade_id
        end
      end

      @tender_invites = TenderInvite.where(:tender_id => @tender_id)
      @documents = TenderDocument.where("user_id = #{session[:user_logged_id]} AND tender_id =#{@tender_id} AND directory != 'unzip'")
      #@documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender_id)

      urls = []
      @directories = []

      if @documents.present?
        @documents.each do |u|
          if u.directory != 'unzip'
            @directories << u.directory
            urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
          end
        end
      end
      @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
      @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => @tender_id)
    end

    @data = render :partial => 'tenders/filter_by_categories'

  end


  def search_by_documents
    @tender_id = params[:tender_id]
    @search = params[:search]
    @val_array = params[:vals]
    @document_control = params[:document_control]
    @unzip_dirs = []
    @docs1 = []

    packages = Package.where(:tender_id =>  @tender_id)

    @vals = []
    if packages.present?
      packages.each do |a|
        @vals << a.code
      end
    else
      @vals = nil
    end

     puts "@vals------------> #{@vals.inspect}"


    if @tender_id.present?
      @tender = Tender.find(@tender_id)
      @tender_trades = TenderTrade.where(:tender_id => @tender_id)
      @trade_categories = TradeCategory.all
      @trade_array = []
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trade_array << t.trade_id
        end
      end
      @directory_array = []
      @directory_array_1 = []
      @directory_array_2 = []
      @document_array = []
      @category_array = []


      @tender_packages = TenderPackage.where(:tender_id => @tender_id).order("category_id asc")
      @all_tender_packages = TenderPackage.where(:tender_id => @tender_id)

      if @all_tender_packages.present?
        @all_tender_packages.each do |v|
          @category_array << v.category_id
        end
      end

      @package_array = []
      @tender_package_header = []

      if @tender_packages.present?
        @tender_packages.each_with_index do |a,i|
          tc = TradeCategory.find(a.category_id)

          if !@package_array.include? tc.title
            @package_array << tc.title
          end
          @package_array << a.trade_id
          @directory_array_1 << a.category_id
        end
      end

      @tender_package_count = TenderPackage.where(:tender_id => @tender_id).count()

      @tender_package_array = []
      @tender_package_array_1 = []
      @tender_package_array_2 = []
      @trade_ids = []
      if @tender_packages.present?
        @tender_packages.each do |p|
          @trade_ids << p.trade_id
        end
      end

      @tender_invites = TenderInvite.where(:tender_id => @tender_id)
      if @search.present?
        #@unzips = UnzipFile.where("filename LIKE '%#{@search}%' and user_id = #{session[:user_logged_id]} and tender_id = #{ @tender_id} ")
        @documents = TenderDocument.where("document_file_name LIKE '%#{@search}%' and user_id = #{session[:user_logged_id]} and tender_id = #{ @tender_id} OR directory LIKE '%#{@search}%' ")
      else
        #@unzips = UnzipFile.where("user_id = #{session[:user_logged_id]} and tender_id = #{ @tender_id} ")
        @documents = TenderDocument.where(" user_id = #{session[:user_logged_id]} and tender_id = #{ @tender_id} ")
      end

      urls = []
      @directories = []

      if @documents.present?
        @documents.each do |u|
          if u.directory != 'unzip'
            @directories << u.directory
            urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
          end
        end
      end
      @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    end

    if @document_control.present?
      @data = render :partial => 'tenders/search_document_control'
    else
      @data = render :partial => 'tenders/search_by_documents'
    end
  end


  def search_by_trades
    @tender_id = params[:tender_id]
    @trade_id = params[:trade_id]
    @unzip_dirs = []
    @docs1 = []

    if @tender_id.present?
      @tender = Tender.find(@tender_id)
      @tender_trades = TenderTrade.where(:tender_id => @tender_id)
      @trade_categories = TradeCategory.all
      @trade_array = []
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trade_array << t.trade_id
        end
      end

      if session[:role] == 'Sub Contractor'
        @tender_approved = TenderApprovedTrade.where(:tender_id => @tender.id,:status => 'approved')

        @trades_approved = []
        if @tender_approved.present?
          @tender_approved.each do |t|
            trade = Trade.find(t.trade_id)
            @trades_approved << trade.id
          end
        end
      end
      # @directory_array = []
      # @directory_array_1 = []
      # @directory_array_2 = []
      # @document_array = []
       @category_array = []
       @tender_packages = TenderPackage.where(:tender_id => @tender_id)
       @all_tender_packages = TenderPackage.where(:tender_id => @tender_id)

      if @all_tender_packages.present?
        @all_tender_packages.each do |v|
          @category_array << v.category_id
        end
      end

      @package_array = []
      @tender_package_header = []

      if @tender_packages.present?
        @tender_packages.each_with_index do |a,i|
          tc = TradeCategory.find(a.category_id)
          if !@package_array.include? tc.title
            @package_array << tc.title
          end
          @package_array << a.trade_id
          #@directory_array_1 << a.category_id
        end
      end

      @tender_package_count = TenderPackage.where(:tender_id => @tender_id).count()
      @tender_package_array = []
      @tender_package_array_1 = []
      @tender_package_array_2 = []
      @trade_ids = []
      if @tender_packages.present?
        @tender_packages.each do |p|
          @trade_ids << p.trade_id
        end
      end

      @tender_invites = TenderInvite.where(:tender_id => @tender_id)

      if @trade_id.to_i > 0
        packages = Package.where(:tender_id => @tender_id)
        @package_ids = []
        if packages.present?
          packages.each do |a|
            if a.code.include? "#{@trade_id}"
              doc_id =  a.code.split('_')[0]
              #trade_id =  a.code.split('_')[1]
              @package_ids << doc_id
            end
          end
        end
      end
      @tender_packages = TenderPackage.where(:tender_id => @tender_id,:trade_id => @trade_id)
      tender_document_array = []
      if @tender_packages.present?
        @tender_packages.each do |t|
          tender_document_array << t.tender_document_id
        end
      end

      if tender_document_array.present?
        @documents = TenderDocument.where(:id => @package_ids,:tender_id => @tender_id)
      else
        @documents = nil
      end

      if @trade_id.to_i == 0
        if session[:role] == 'Sub Contractor'
          @documents = TenderDocument.where("tender_id = #{ @tender_id}")
        else
          @documents = TenderDocument.where(" user_id = #{session[:user_logged_id]} and tender_id = #{ @tender_id}")
        end

      end
      urls = []
      @directories = []

      # if @documents.present?
      #   @documents.each do |u|
      #     if u.directory != 'unzip'
      #       @directories << u.directory
      #       urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
      #     end
      #   end
      # end
      #@new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    end
    @data = render :partial => 'tenders/search_document_control'
  end


  def publish
    tender_id = params[:tender_id]
    tender = Tender.find(tender_id)
    Tender.where(:id => tender_id).update_all(:publish => true)
    invites = TenderInvite.where(:tender_id => tender_id)

    if invites.present?
      invites.each do |a|
        if a.trade_id.present?
          t = Trade.find(a.trade_id)

          user = User.where(:email => a.email).first
          sc_invite_notif = ScInviteNotification.new

          if user.present?
            sc_invite_notif.user_status =  'user'
            sc_invite_notif.user_id = user.id
            path = "http://"+request.host_with_port+"/users/login?email=#{user.email}&tender=#{tender_id}&trade=#{t.id}"
          else
            sc_invite_notif.user_status =  'not_user'
            decline_path = "http://"+request.host_with_port+"/invites/decline_tender_invite?tender_id=#{tender_id}&email=#{a.email}&trade=#{t.id}"
            path = "http://"+request.host_with_port+"/users/register?name=#{a.name}&email=#{a.email}&tender=#{tender_id}&trade=#{t.id}"
          end

          sc_invite_notif.seen = 0
          sc_invite_notif.tender_id = tender_id
          sc_invite_notif.message = "Invitation for tender #{tender.title} (#{t.name})"
          sc_invite_notif.save
          TenderconMailer.delay.sent_sc_invites(a.email,a.name,t.name,path,decline_path)
        end
      end
    end

    tender_invites = TenderInvite.where(:tender_id => tender.id)
    user_array = []
    if tender_invites.present?
      tender_invites.each do |u|
        user = User.where(:email => u.email).first

        if user.present?
          user_array << "#{user.id}"
        end
      end
    end

    sub_contractors = User.where(:role => 'Sub Contractor')
    puts "sub_contractors -----------------------> publish #{sub_contractors.inspect}"
    puts "user_array ------------------> #{user_array.inspect}"
    if sub_contractors.present?
      sub_contractors.each do |u|
        open_tender = OpenTender.new
        open_tender.tender_id = tender_id
        puts " !user_array.include? '#{u.id}' #{!user_array.include? "#{u.id}"}"
        if !user_array.include? "#{u.id}"
          puts "------------------> u.id #{u.id}"
          open_tender.user_id = u.id
        end
        open_tender.tender_id = tender_id
        if open_tender.user_id != nil
          open_tender.save
        end

      end
    end

    Tender.delay.compressed_document(tender_id)

    redirect_to "/tenders/completed?id=#{tender_id}"
  end

  def completed
    id = params[:id]

    @tender = Tender.find(id)
  end

  def my_tender
    if session[:role] == 'Head Contractor'
      @tenders = Tender.where(:user_id => session[:user_logged_id],:publish => true)
      @trade_categories = TradeCategory.all
    else
      @trade_categories = TradeCategory.all
      user_tenders = TenderRequestQuote.where(:sc_id => session[:user_logged_id])
      tender_array = []
      if user_tenders.present?
        user_tenders.each do |t|
          tender_array << t.tender_id
        end
      end

      if tender_array.present?
        @tenders = Tender.where(:id => tender_array,:publish => true)
        @t_array = tender_array
      else
        @tenders = nil
      end
    end
  end


  def invited_tender
    if session[:role] == 'Head Contractor'
      @tenders = Tender.where(:user_id => session[:user_logged_id])
      @trade_categories = TradeCategory.all
    else
      puts "params[:]:#{params[:params]}"
      if params[:params].present?
        @tender_id = params[:params]
        ScInviteNotification.where(:tender_id => @tender_id).update_all(:seen => 1)
      end
      tender_invites = TenderInvite.where("email = '#{session[:email]}' and (status is null OR status = 'opened')")
      tender_array = []
      if tender_invites.present?
        tender_invites.each do |a|
          tender_array << a.tender_id
          invite = TenderInvite.where(:tender_id => a.tender_id,:trade_id => a.trade_id,:email => session[:email]).update_all(:status => 'opened',:tender_open_date => Time.now)
        end
      end

      @trade_categories = TradeCategory.all
      if tender_array.present?
        @tenders = Tender.where(:id => tender_array)
        @t_array = tender_array
      else
        @tenders = nil
      end
    end
  end

  def open_tender
    if session[:role] == 'Head Contractor'
      @tenders = Tender.where(:user_id => session[:user_logged_id])
      @trade_categories = TradeCategory.all
    else
      @trade_categories = TradeCategory.all
      @ip = request.host_with_port
      # tender_array = []
      # all_quote_array = []
      # @trade_categories = TradeCategory.all
      # user_tenders = TenderRequestQuote.where("sc_id != #{session[:user_logged_id]}")
      # all_quote_tenders = TenderRequestQuote.all
      # @user_quote = TenderRequestQuote.where(:sc_id => session[:user_logged_id]).last
      # @tender_count = Tender.all.count()
      # @sectors = Category.all
      # @values = TenderValue.all
      # @primary_trade_array = []
      # @secondary_trade_array = []
      # @primary_trade = PrimaryTrade.where(:user_id => session[:user_logged_id])
      # @secondary_trade = SecondaryTrade.where(:user_id => session[:user_logged_id])
      # @ip = request.host_with_port
      #
      # if @primary_trade.present?
      #   @primary_trade.each do |p|
      #     @primary_trade_array << p.trade_id
      #   end
      # end
      #
      # if @secondary_trade.present?
      #   @secondary_trade.each do |s|
      #     @secondary_trade_array << s.trade_id
      #   end
      # end

      # @tender_array = @primary_trade_array + @secondary_trade_array
      # @tender_trades_count = TenderTrade.where(:trade_id => @tender_array).count()
      #
      # if @user_quote.present?
      #   #date_time = DateTime.parse("'#{@user_quote.created_at}'")
      #   # date_time.class # => DateTime
      #   @range_month = (@user_quote.created_at + 1.month) >= Time.now + 1.month#((Date.today + 1.month) - ('2016-09-12'.to_date)).to_i
      # else
      #   @range_month = nil
      # end
      #
      # tenders = Tender.all
      # tender_array1 = []
      # if tenders.present?
      #   tenders.each do |t|
      #     tender_array1 << t.id
      #   end
      # end
      #
      # if all_quote_tenders.present?
      #   all_quote_tenders.each do |a|
      #     if a.sc_id == session[:user_logged_id]
      #       all_quote_array << a.tender_id
      #     end
      #   end
      # end
      #
      # tender_invites = TenderInvite.all
      # tender_invite_array = []
      # if tender_invites.present?
      #   tender_invites.each do |t|
      #     tender_invite_array << t.tender_id
      #   end
      # end
      #
      # if tender_array1.present?
      #   tender_array1.each do |u|
      #     if !all_quote_array.include? u
      #       tender_array << u
      #     end
      #   end
      # end
      #
      # if tender_invite_array.present?
      #   tender_invite_array.uniq.each do |del|
      #     if tender_array.include? del
      #       tender_array.delete_at(tender_array.index(del))
      #     end
      #   end
      # end
      #
      open_tenders = OpenTender.where(:user_id => session[:user_logged_id])
      tender_arr = []
      if open_tenders.present?
        open_tenders.each do |a|
          tender_arr << a.tender_id
        end
      end

      puts "open tender tender_arr-------------> #{tender_arr.inspect}"

      if tender_arr.present?
        @tenders = Tender.where(:id => tender_arr.uniq)
      else
        @tenders = nil
      end

      # if tender_array.present?
      #   @tenders = Tender.where(:id => tender_array.uniq)
      #   @t_array = tender_array
      # else
      #   @tenders = nil
      # end
    end
  end

  def filter_open_tender
    filters = params[:filters]
    puts "filters:#{filters.inspect}"

    values = []
    distances = []
    dues = []
    sectors = []
    category_ids = []
    tender_value_ids = []

    if filters.present?
      filters.each do |f|
        if f.include? "K"
          values << f
        elsif f.include? "M"
          values << f
        elsif f.include? "kms"
          distances << f
        elsif f.include? "hrs"
          dues << f
        elsif f.include? "days"
          dues << f
        else
          sectors << f
        end
      end
    end
    puts "values:#{values}"
    puts "distances:#{distances}"
    puts "dues:#{dues}"
    puts "sectors:#{sectors}"
    categories = Category.where(:name => sectors)
    tender_values = TenderValue.where(:range => values)
    #tender_quote = TenderQuote.where(:range => values)



    if categories.present?
      categories.each do |c|
        category_ids << c.id
      end
    end
    #require 'date'

    quote_tender_array = []
    if dues.present?
      date_array = []
      tender_quotes_ids = []

      tender_quote = TenderQuote.all
      if  tender_quote.present?
        tender_quote.each do |t|
          date = Date.strptime(t.quote_date, "%m/%d/%Y")
          date_array <<  date
          tender_quotes_ids << t.tender_id
        end
      end
      dues.each do |d|
        if d.include? "< 24 hrs"
          now = (Time.now - 1.day).strftime("%Y-%m-%d")
          puts "NOW:#{now}"

          if date_array.present?
            date_array.each_with_index do |d,index|
              if now <= d.to_datetime
                quote_tender_array << tender_quotes_ids[index]
                puts "tender_quotes_ids:#{tender_quotes_ids[index]}"
              end
            end
          end
        end

        if d.include? "< 7 days"
          now = (Time.now - 7.days).strftime("%Y-%m-%d")

          if date_array.present?
            date_array.each_with_index do |d,index|
              if now <= d.to_datetime
                quote_tender_array << tender_quotes_ids[index]
              end
            end
          end
        end

        if d.include? "> 7 days"
          now = (Time.now + 30.days).strftime("%Y-%m-%d")
          if date_array.present?
            date_array.each_with_index do |d,index|
              if now <= d.to_datetime
                quote_tender_array << tender_quotes_ids[index]
              end
            end
          end
        end
      end
    end

    if tender_values.present?
      tender_values.each do |v|
        tender_value_ids << v.id
      end
    end
    puts "tender_value_ids:#{tender_value_ids}"
    tender_per_distance = []
    if distances.present?
      user = User.find(session[:user_logged_id])
      user_address = Geocoder.coordinates(user.address.location)
      current_location =  Geokit::LatLng.new(user_address[0],user_address[1])
      tenders = Tender.all

      if tenders.present?
        tenders.each do |t|
          tender_location = Geocoder.coordinates(t.address)
          destination = "#{tender_location[0]},#{tender_location[1]}"
          distance = current_location.distance_to(destination)/1.61

          distances.each do |d|
            if d.include? "< 15kms"
               if distance.to_i  < 15
                 tender_per_distance << t.id
               end
            end

            if d.include? "< 50kms"
              if distance.to_i  < 50
                tender_per_distance << t.id
              end
            end

            if d.include? "< 100kms"
              if distance.to_i  < 100
                tender_per_distance << t.id
              end
            end

            if d.include? "< 200kms"
              if distance.to_i  < 200
                tender_per_distance << t.id
              end
            end

            if d.include? "> 200kms"
              if distance.to_i  > 200
                tender_per_distance << t.id
              end
            end
          end
        end
      end
    end

    tender_per_categories = []
    tender_per_values = []
    tender_cat = Tender.where(:category_id => category_ids)
    tender_val = Tender.where(:tender_value_id => tender_value_ids)

    if tender_cat.present?
      tender_cat.each do |t|
        tender_per_categories << t.id
      end
    end

    if  tender_val.present?
      tender_val.each do |t|
        tender_per_values << t.id
      end
    end

    puts "tender_per_distance:#{tender_per_distance.inspect}"
    puts "tender_per_categories:#{tender_per_categories.inspect}"
    puts "tender_per_values:#{tender_per_values.inspect}"
    puts "quote_tender_array:#{quote_tender_array.inspect}"
    new_tender_array =  tender_per_distance +  tender_per_categories +  tender_per_values + quote_tender_array

    if new_tender_array.present?
      tender_invites = TenderInvite.all
      tender_invite_array = []
      if tender_invites.present?
        tender_invites.each do |t|
          tender_invite_array << t.tender_id
        end
      end

      tender_request_quotes = TenderRequestQuote.where(:sc_id => session[:user_logged_id])
      tender_quote_array = []
      if tender_request_quotes
        tender_request_quotes.each do |t|
          tender_quote_array << t.tender_id
        end
      end
      need_to_remove_arr = tender_invite_array.uniq +  tender_quote_array.uniq
      puts "need_to_remove_arr:#{need_to_remove_arr.inspect}"

      if need_to_remove_arr.present?
        need_to_remove_arr.uniq.each do |r|
          if new_tender_array.uniq.include? r
            new_tender_array.delete(r)
          end
        end
      end
      tender_array =  new_tender_array#need_to_remove_arr.uniq -  new_tender_array.uniq
    else
      tender_array = nil
    end

    if tender_array.present?
      @tenders = Tender.where(:id => tender_array.uniq)
      @t_array = tender_array
    else
      @tenders = nil
    end
    @data = render :partial => 'tenders/search_per_filter'
  end

  def request_to_quote
    tender_id = params[:tender_id]
    sc_id = params[:sc_id]
    ids = params[:ids]

    tender = Tender.find(tender_id)
    @tender_id = tender.id
    if !params[:open].present?
      invites = TenderInvite.where("tender_id = #{tender_id} and email = '#{session[:email]}'")
      boolean_array = []
      trade_ids = []
      tender_ids = []
      if invites.present?
        invites.each do |a|
          if a.status == 'accepted'
            boolean_array << true
            trade_ids <<  a.trade_id
            tender_ids << a.tender_id
          end
        end
      end
    end

    if params[:tender_detail].present?
      puts "tender_detail ---------------> "
      ids.each do |i|
        if i != 'on'
          if !TenderRequestQuote.check_sc_tender_trade_exists? tender_id,i,sc_id,tender.user_id
            puts "==================> tender_detail"
            puts "TRADE ID =========> #{i}"
            tender_request_quote = TenderRequestQuote.new
            tender_request_quote.tender_id = tender_id
            tender_request_quote.sc_id = sc_id
            tender_request_quote.hc_id = tender.user_id
            tender_request_quote.trade_id = i
            tender_request_quote.request_date = Time.now
            tender_request_quote.hc_id = tender.user_id
            tender_request_quote.save
          end
        end
      end
    end

    if params[:open].present?
      puts "open ---------------> "
      ids.each do |i|
        if !TenderRequestQuote.check_sc_tender_trade_exists? tender_id,i,sc_id,tender.user_id
          if i.to_i > 0
            puts "==================> OPEN TENDER SAVE"
            tender_request_quote = TenderRequestQuote.new
            tender_request_quote.tender_id = tender_id
            tender_request_quote.sc_id = sc_id
            tender_request_quote.hc_id = tender.user_id
            tender_request_quote.trade_id = i
            tender_request_quote.request_date = Time.now
            tender_request_quote.hc_id = tender.user_id
            tender_request_quote.save
          end
        end
      end

      OpenTender.where(:tender_id => tender_id,:user_id => sc_id).destroy_all

    elsif boolean_array.include? true
      puts "boolean_array ---------------> "

      if trade_ids.present?
        trade_ids.each_with_index do |t,index|
          request_quote = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => sc_id,:hc_id => tender.user_id,:trade_id => t).first

          if !TenderRequestQuote.check_sc_tender_trade_exists? tender_id,t,sc_id,tender.user_id
            if t.to_i > 0
              puts "==================> boolean_array"
              tender_request_quote = TenderRequestQuote.new
              tender_request_quote.tender_id = tender_id
              tender_request_quote.sc_id = sc_id
              tender_request_quote.hc_id = tender.user_id
              tender_request_quote.trade_id = t
              tender_request_quote.request_date = Time.now
              tender_request_quote.approved_date = Time.now
              tender_request_quote.hc_id = tender.user_id
              tender_request_quote.status =  'approved'
              tender_request_quote.save

              approved = TenderApprovedTrade.new
              approved.tender_id = tender_ids[index]
              approved.sc_id = sc_id
              approved.hc_id = tender_request_quote.hc_id
              approved.trade_id = t
              approved.status = 'approved'
              approved.tender_request_quote_id = tender_request_quote.id
              approved.save
            end
          end
        end

      end
    else
      puts "boolean_array1 ---------------> "
      if !params[:tender_detail].present?
        open_tender = OpenTender.new
        open_tender.user_id = sc_id
        open_tender.tender_id = tender_id
        open_tender.save
      end

        if ids.present?
          ids.each do |i|
            open_tnder = OpenTenderTrade.where(:tender_id => tender_id,:user_id => sc_id,:trade_id => i).first

            if !open_tnder.present?
              open_tender_trade = OpenTenderTrade.new
              open_tender_trade.tender_id = tender_id
              open_tender_trade.user_id = sc_id
              open_tender_trade.trade_id = i
              open_tender_trade.save
            end
          end
        end

    end

    TenderRequestQuote.where("trade_id is null").delete_all()
    if params[:tender_detail].present?
      @data = render :partial =>  'tenders/info/tender_details'
    else
      render :json => { :state => 'valid'}
    end


  end

  def new
    #@tender = Tender.new
    @user = User.find(session[:user_logged_id])
    @categories = Category.all
    @values = TenderValue.all
    @trades = Trade.all
    @trade_categories = TradeCategory.all
    @tender_document = TenderDocument.new
    @tender_files = TenderDocument.new

    @directories = []
    @documents = TenderDocument.all

    if @documents.present?
      @documents.each do |t|
        @directories << t.directory
      end
    end
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id])
    @documents = TenderDocument.where(:user_id => session[:user_logged_id])
    urls = []
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          if u.directory.present?
            @directories << u.directory
          end
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
  end

  def create_tender_info
    tender_id = params[:tender_id]

    if tender_id.present?
      Tender.where(:id => tender_id).update_all(
        :title => params[:title],
        :client => params[:client],
        :category_id => params[:categories],
        :title => params[:architect],
        :architect => params[:title],
        :tender_value_id => params[:values],
        :description => params[:about_me],
        :address => params[:original_address],
        :suburb => params[:suburb],
        :postcode => params[:postcode],
        :state => params[:state],
        :address_terms => params[:address_terms],
        :status => params[:tendering],
        :user_id => session[:user_logged_id],
        :tendercon_id => params[:tendercon_id]
      )

      TenderQuote.where(:tender_id => tender_id).destroy_all
      TenderSite.where(:tender_id => tender_id).destroy_all
      quotes = TenderQuote.new
      quotes.tender_id = tender_id
      quotes.quote_date = params[:quote]
      quotes.quote_description = params[:quote_description]
      quotes.save

      if params[:site].present?
        params[:site].each_with_index  do |s,index|
          site = TenderSite.new
          site.site_date = s
          site.tender_id = tender_id
          site.user_id = session[:user_logged_id]
          site.save
        end
        TenderSite.where(:site_date => '').destroy_all()
        TenderSite.where(:user_id => session[:user_logged_id]).update_all(:tender_id => tender_id)
      end
      #redirect_to "/tenders/new_tender?reviews=true&info_id=#{tender_id}"
      redirect_to "/tenders/new_tender?trades=true&info_id=#{tender_id}"
    else

      @tender = Tender.new
      @tender.title = params[:title]
      @tender.client = params[:client]
      @tender.category_id = params[:categories]
      @tender.architect = params[:architect]
      @tender.tender_value_id = params[:values]
      @tender.description = params[:about_me]
      @tender.address = params[:original_address]
      @tender.suburb = params[:suburb]
      @tender.state = params[:state]
      @tender.postcode = params[:postcode]
      @tender.address_terms = params[:address_terms]
      @tender.status = params[:tendering]
      @tender.user_id = session[:user_logged_id]
      @tender.tendercon_id = params[:tendercon_id]

      if params[:title].present? && params[:original_address].present? && params[:quote].present? && params[:values].to_i > 0 && params[:categories].to_i > 0
        if @tender.save
          quotes = TenderQuote.new
          quotes.tender_id = @tender.id
          quotes.quote_date = params[:quote]
          quotes.quote_description = params[:quote_description]
          quotes.save

          if params[:site].present?
            params[:site].each_with_index  do |s,index|
              site = TenderSite.new
              site.site_date = s
              site.tender_id = @tender.id
              site.user_id = session[:user_logged_id]
              site.save
            end
          end
          TenderSite.where(:site_date => '').destroy_all()
          TenderSite.where(:user_id => session[:user_logged_id]).update_all(:tender_id => @tender.id)
          redirect_to "/tenders/new_tender?trades=true&info_id=#{@tender.id}"

        end
      else
        @categories = Category.all
        @values = TenderValue.all
        @unzip_dirs = []
        @docs1 = []
        @trade_category_array = []
        @trade_categories = TradeCategory.all
        @tender_document = TenderDocument.new
        @tender_files = TenderDocument.new
        @trade_names = []
        if @trades.present?
          @trades.each do |t|
            @trade_names << t.name
          end
        end

        @errors = []

        if !params[:title].present?
          @errors << 'Title is required'
          @title_error = 'Title is required'
        end

        if !params[:original_address].present?
          @errors << 'Address is required'
          @address_error = 'Address is required'
        end

        if !params[:quote].present?
          @errors << 'Quote due is required'
          @quote_due_error = 'Quote due is required'
        end

        if params[:values].to_i <= 0
          @errors << 'Value is required'
          @value_error = 'Value is required'
        end

        if params[:categories].to_i  <= 0
          @errors << 'Sector is required'
          @sector_error = 'Sector is required'
        end

        puts "sdsdjhsdjshjdhsjshjshd----> #{@tender.errors.full_messages}"
        render 'new_tender'
      end

    end
  end

  def create_tender_trades
    tender_id = params[:tender_id]
    trades = params[:trade]
    trade_lists =  params[:trade_lists]

    if params[:save_trade].present?

      TenderTrade.where(:tender_id => tender_id).destroy_all

      if trades.present?
        trades.each do |t|
          if t.present?

            upper_case = t.strip.upcase
            lower_case = t.strip.downcase
            upcase_first_letter = t.strip.titleize
            tr = Trade.where("name ='#{upper_case}' OR name = '#{lower_case}' OR name = '#{upcase_first_letter}'").first

            if !tr.present?
              new_trade = Trade.new
              new_trade.name = t
              new_trade.trade_category_id = 5
              new_trade.save

              trade = TenderTrade.new
              trade.tender_id = tender_id
              trade.trade_id = new_trade.id
              trade.save
            end
          end
        end
      end

      if trade_lists.present?
        trade_lists.each do |t|
          trade = TenderTrade.new
          trade.tender_id = tender_id
          trade.trade_id = t
          trade.save
        end
      end
      redirect_to "/tenders/new_tender?document=true&info_id=#{tender_id}"
      #redirect_to "/tenders/new_tender?reviews=true&info_id=#{tender_id}"
    else
      if trades.present?
        trades.each do |t|
          if t.present?
            upper_case = t.strip.upcase
            lower_case = t.strip.downcase
            upcase_first_letter = t.strip.titleize
            tr = Trade.where("name ='#{upper_case}' OR name = '#{lower_case}' OR name = '#{upcase_first_letter}'").first

            if !tr.present?
              new_trade = Trade.new
              new_trade.name = t
              new_trade.trade_category_id = 5
              new_trade.save

              trade = TenderTrade.new
              trade.tender_id = tender_id
              trade.trade_id = new_trade.id
              trade.save
            end
          end
        end
      end

      if trade_lists.present?
        trade_lists.each do |t|
          trade = TenderTrade.new
          trade.tender_id = tender_id
          trade.trade_id = t
          trade.save
        end
      end
      redirect_to "/tenders/new_tender?document=true&info_id=#{tender_id}"
    end
  end

  def update_document_status
    val = params[:val]
    tender_id = params[:tender_id]
    Tender.where(:id => tender_id).update_all(:hide_document => val);
    render :json => { :state => 'valid'}
  end

  def new_site
    @id = (params[:id]).to_i + 1
    tender_date = params[:site_date]
    quote = params[:quote_date]


    if tender_date.to_datetime >  quote.to_datetime
      render :json => { :state => 'invalid',:error => 'Quote'}
    else
      old_site = TenderSite.where(:site_date => tender_date,:user_id => session[:user_logged_id]).first

      if old_site.present?
        render :json => { :state => 'invalid',:error => 'Exists'}
      else
        tender_site = TenderSite.new
        tender_site.site_date =  tender_date
        tender_site.user_id = session[:user_logged_id]
        tender_site.save
        @tender_sites = TenderSite.where(:user_id => session[:user_logged_id],:tender_id => nil)
        @data = render :partial => 'tenders/tender_sites/lists'
      end

    end


  end

  def add_revision
    tender_id = params[:tender_id]
    id = params[:id]
    val = params[:val]
    @unzip_dirs = []
    @docs1 = []

    begin
      tender = TenderDocument.find(id)
      if tender.present?
        TenderDocument.where(:id => tender.id).update_all(:revision => val)
      end
    rescue
      unzip = UnzipFile.find(id)
      if unzip.present?
        UnzipFile.where(:id => unzip.id).update_all(:revision => val)
      end
    end

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id)
    urls = []
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    if @unzips.present?
      @unzips.each do |u|
        @new_direcotires << u.directory
      end
    end
    @tender = Tender.find(tender_id)
    @data = render :partial => 'tenders/documents'
  end

  def get_latling
    add = params[:add]
    user_address = Geocoder.coordinates(add)
    if user_address.present?
      @latitue =  user_address[0]
      @longitude = user_address[1]
      render :json => { :state => 'valid',:latitude => @latitue, :longitude => @longitude}
    else
      render :json => { :state => 'valid',:latitude => 0, :longitude => 0}
    end
  end

  def update_revision
    category = params[:category]
    tender_id = params[:tender_id]
    val = params[:val]
    @unzip_dirs = []
    @docs1 = []
    unzip = UnzipFile.where(:user_id => session[:user_logged_id],:directory => category,:tender_id => tender_id)

    if unzip.present?
      if val.present?
        UnzipFile.where(:tender_id => tender_id,:directory => category).update_all(:revision => val)
        TenderDocument.where(:tender_id => tender_id,:directory => category).update_all(:revision => val)
      else
        new_unzip = UnzipFile.where("tender_id = #{tender_id} and directory = '#{category}' and revision is not null").first
        if new_unzip.present?
          UnzipFile.where(:tender_id => tender_id,:directory => category).update_all(:revision => new_unzip.revision)
          TenderDocument.where(:tender_id => tender_id,:directory => category).update_all(:revision => new_unzip.revision)
        end
      end
    else
      documents = TenderDocument.where(:user_id => session[:user_logged_id],:directory => category,:tender_id => tender_id)
      if documents.present?
        if val.present?
          TenderDocument.where(:tender_id => tender_id,:directory => category).update_all(:revision => val)
          UnzipFile.where(:tender_id => tender_id,:directory => category).update_all(:revision => val)
        else
          documents.each do |u|
            new_document = TenderDocument.where("directory = '#{category}' and  tender_id = #{tender_id} and revision is not null").first

            if new_document.present?
              TenderDocument.where(:tender_id => tender_id,:directory => category).update_all(:revision => new_document.revision)
              UnzipFile.where(:tender_id => tender_id,:directory => category).update_all(:revision => new_document.revision)
            end
          end
        end
      else
        unzip = UnzipFile.where("tender_id = #{tender_id} and revision is not null").first
        if unzip.present?
          UnzipFile.where(:tender_id => tender_id,:directory => category).update_all(:revision => unzip.revision)
        end
      end
    end

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id)
    urls = []
    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    if @unzips.present?
      @unzips.each do |u|
        @new_direcotires << u.directory
      end
    end
    @tender = Tender.find(tender_id)
    @data = render :partial => 'tenders/documents'
  end

  def create_document
    document = TenderDocument.new

    document.document = params[:document]
    document.user_id = params[:tender_document][:user_id]
    puts "jhasdhasjhdjsd------------->#{params[:new_dir]}"
    if params[:new_dir].present?
      document.directory = params[:new_dir]
      new_file_doc = TenderDocument.where("directory = '#{params[:new_dir]}' AND tender_id = #{params[:tender_id]}").last
      document.created_at = new_file_doc.created_at
      document.updated_at = new_file_doc.updated_at

    else
      search = 'Header'
      doc = TenderDocument.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last

      if doc.present?
        #zip = UnzipFile.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last
        #if zip.present?
        #  @zip_last = zip.directory[/\d+/]
        #end

        last = doc.directory[/\d+/]
        new = (last).to_i + 1
        #if @zip_last.to_i > last.to_i
        #  new = (@zip_last).to_i + 1
        #else
        #  new = (last).to_i + 1
        #end
        document.directory = "Header#{new}"
      else
        # zip = UnzipFile.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last
        #
        # if zip.present?
        #   last = zip.directory[/\d+/]
        #   new = (last).to_i + 1
        #   document.directory = "Header#{new}"
        # else
          document.directory = "Header1"
        #end
      end
    end

    document.tender_id = params[:tender_id]
    if document.save
      TenderDocument.where(:id => document.id).update_all(:document_path => document.document.path)
      url = "#{Rails.root}/public/assets/tender/document/#{document.id}/original/#{document.document_file_name}"
      urls = []

      if params[:unzip].present? && File.extname(document.document_file_name) == '.zip'
        puts "Zip================>"
        require 'zip'
        document = TenderDocument.find(document.id)
        @ids = []
        if document.present?
          doc = File.extname(document.document_file_name)
          file_path = Rails.root + "public/assets/tender/document/#{document.id}/original/"
          if doc == '.zip'
            @ids << document.id
            if File.exist?(document.document.path)
              Zip::File.open(document.document.path) {|zip_file|
                zip_file.each { |f|
                  f_path = File.join(file_path,f.name)
                  zip_file.extract(f,f_path) unless File.exist?(f_path)
                }
              }
              FileUtils.rm(document.document.path)
              TenderDocument.where(:id => document.id).update_all(:directory => 'unzip')
            end
          end
        end

        if @ids.present? && @ids.size > 0
          @ids.each do |i|
            folder =  Rails.root + "public/assets/tender/document/#{i}/original/"
            dir = Dir.glob("#{folder}/**/*")

            if dir.present?
              dir.each do |d|
                file = File.basename(d)
                ext = File.extname(d)
                size = File.size(d)
                doc = TenderDocument.find(i)

                if ext != '.zip' && ext.present?
                  unzip = UnzipFile.new
                  unzip.path = d
                  unzip.user_id = doc.user_id
                  unzip.file_size = size
                  unzip.filename = file
                  unzip.tender_document_id = i
                  unzip.extension = ext
                  unzip.tender_id = params[:tender_id]
                  path = File.dirname(d)
                  base = File.basename(path)
                  if base.to_s != 'original'
                    unzip.directory = base
                  else
                    search = 'Header'
                    doc = TenderDocument.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last
                    if doc.present?
                      last = doc.directory[-1, 1]
                      new = (last).to_i + 1
                      zip = UnzipFile.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last

                      if zip.present?
                        last = zip.directory[-1, 1]
                        new = (last).to_i + 1
                        doc_last = doc.directory[-1, 1]

                        if doc_last.to_i > last.to_i
                          new = (doc_last).to_i + 1
                          unzip.directory = "Header#{new}"
                        else
                          new = (last).to_i + 1
                          unzip.directory = "Header#{new}"
                        end
                      else
                        doc_last = doc.directory[-1, 1]
                        new = (doc_last).to_i + 1
                        unzip.directory = "Header#{new}"
                      end
                    else
                      zip = UnzipFile.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last
                      if zip.present?
                        last = zip.directory[-1, 2]
                        new = (last).to_i + 1
                        unzip.directory = "Header#{new}"
                      else
                        unzip.directory = "Header1"
                      end
                    end
                  end
                  unzip.save
                end
              end
            end
          end
        end

        @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => params[:tender_id])
        @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => params[:tender_id])
        urls = []
        @directories = []

        if @documents.present?
          @documents.each do |u|
            if u.directory != 'unzip'
              @directories << u.directory
              urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
            end
          end
        end
        @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
      end

      @documents = TenderDocument.where(:user_id => params[:tender_document][:user_id])
      if @documents.present?
        @documents.each do |u|
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
      #TenderDocument.where("directory is null or tender_id is null or document_file_name is null").delete_all
      direct_without_files =  TenderDocument.where("directory is null or tender_id is null or document_file_name is null")

      if direct_without_files.present?
        @dir_ids = []
        direct_without_files.each do |d|
          @dir_ids << d.directory
        end

        if @dir_ids.present?
          @dir_ids.each do |d|
           dir_cnt = TenderDocument.where(:directory => d).count()

           if dir_cnt > 1
             TenderDocument.where("directory = '#{d}' and document_file_name is null").delete_all
           end
          end
        end
      end
      TenderDocument.where(:directory => 'unzip').delete_all()
      TenderDocument.where(:document_file_name => ".DS_Store").delete_all

      @unzip_ids = []
      if @unzips.present?
        @unzips.each do |u|
          new_document = TenderDocument.new
          new_document.document = File.open(u.path)
          if u.directory.include? "Header"
            search = "Header"
            doc = TenderDocument.where("directory LIKE '%#{search}%' AND tender_id = #{params[:tender_id]}").last

            if doc.present?
              last = doc.directory[/\d+/]
              new = (last).to_i + 1
              new_document.directory = "Header #{new}"
            else
              new_document.directory = "Header 1"
            end
          else
            new_document.directory = u.directory
          end

          new_document.tender_id = u.tender_id
          new_document.user_id = u.user_id
          new_document.save
          @unzip_ids << u.id
        end
      end

      if @unzip_ids.present?
        UnzipFile.where(:id => @unzip_ids).delete_all()
      end
      if params[:new_dir].present?
        render :json => { :state => 'valid',:new_dir => params[:new_dir]}
      else
        render :json => { :state => 'valid',:avatar_url => url}
      end
    else
      render :json => { :state => 'invalid',:errors => 'Image should be jpg and png. And maximum of 1mb.'}
    end
  end

  def create_package
    tender_id = params[:tender_id]
    ids = params[:ids]
    TenderPackage.where(:tender_id => tender_id).destroy_all

    if ids.present?
      ids.each do |id|
        trade = Trade.find(id)
        category = TradeCategory.find(trade.trade_category_id)
        tender_package = TenderPackage.new
        tender_package.tender_id = tender_id
        tender_package.trade_id = id
        tender_package.category_id = category.id
        tender_package.save
      end
    end
    render :json => { :state => 'valid',:tender_id => tender_id}
  end

  def create_partitions
    packages = params[:package]
    tender_id = params[:tender_id]
    addenda = params[:addenda]
    docs = Hash.new
    document_array = []
    @array = []
    if !addenda.present?
      if params[:file_id].present?
        Package.where("code LIKE ?", "%#{params[:file_id]}%").destroy_all
      else
        Package.where(:tender_id => tender_id).destroy_all
      end
    end


    if packages.present?
      packages.each do |a|
        package = Package.new
        package.tender_id = tender_id
        package.code = a
        package.save

        b =  a.split('_')[0]
        c =  a.split('_')[1]
        document_array << c
        if a.include? "#{c}"
          @array << b
          docs["#{c}"] = @array.uniq
        end
      end
    end

    if document_array.present?
      document_array.uniq.each do |a|
        trade = Trade.find(a)
        if trade.present?
          if trade.name.include? "/"
            dir = "#{Rails.root}/public/assets/tender/document/#{trade.name.gsub!('/','-')}"
          else
            dir = "#{Rails.root}/public/assets/tender/document/#{trade.name}"
          end

          Dir.mkdir(dir) unless File.exists?(dir)

          if packages.any? { |s| s.include?("#{a}") }
            new_array =  packages.each_index.select{|i| packages[i] =~ /#{a}/}
            if new_array.present?
              new_array.each do |f|
                b =  packages[f].split('_')[0]
                puts "ddhfjdshfjdhsfjhdsj-----------> #{b}"
                c =  packages[f].split('_')[1]
                begin
                  doc = TenderDocument.where(:id => b).first
                  puts "doc-------------------------> #{doc.document_path}"
                  if doc.present?
                    if doc.document_path.present?
                      dir_1 = "#{dir}/#{doc.directory}"
                      FileUtils.mkdir_p "#{dir_1}"
                      if File.file?(doc.document_path)
                        FileUtils.cp(doc.document_path, dir_1)
                      end
                    else
                      file_path = "#{Rails.root}/public/assets/tender/document/#{doc.id}/original/#{document_file_name}"
                      FileUtils.cp(file_path, dir_1)
                    end
                  else

                  end

                rescue
                  # doc = TenderDocument.where(:id => b).first
                  #
                  # if doc.present?
                  #   dir_1 = "#{dir}/#{doc.directory}"
                  #   FileUtils.mkdir_p "#{dir_1}"
                  #   if File.file?(doc.document_path)
                  #     FileUtils.cp(doc.document_path, dir_1)
                  #   end
                  # end
                  # begin
                  #   zip = UnzipFile.find(b)
                  #
                  #   if zip.present?
                  #     dir_1 = "#{dir}/#{zip.directory}"
                  #     FileUtils.mkdir_p "#{dir_1}"
                  #     FileUtils.cp(zip.path, dir_1)
                  #   end
                  # end

                end
              end
            end
          end
          DocumentPackage.where(:tender_id =>  tender_id).destroy_all
          Tender.delay.compressed_document_matrix(dir,tender_id,session[:user_logged_id],request.host_with_port)
        end
      end
    end
    if addenda.present?
      redirect_to review_addendas_path(:id => tender_id,:addenda => addenda,:addenda_type => 'documents')
    else
      redirect_to "/tenders/new_tender?invites=true&info_id=#{tender_id}"
    end

  end

  def create_files
    document = TenderDocument.new
    document.document = params[:document]
    document.user_id = params[:tender_document][:user_id]
    if params[:new_dir].present?
      document.directory = params[:new_dir]
    end

    if document.save
      url = "#{Rails.root}/public/assets/tender/document/#{document.id}/original/#{document.document_file_name}"
      urls = []
      @documents = TenderDocument.where(:user_id => params[:tender_document][:user_id])

      if @documents.present?
        @documents.each do |u|
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
      render :json => { :state => 'valid',:avatar_url => url}
    else
      render :json => { :state => 'invalid',:errors => 'Image should be jpg and png. And maximum of 1mb.'}
    end
  end


  def unzip
    require 'zip'
    documents = TenderDocument.where(:user_id => session[:user_logged_id])
    @ids = []
    if documents.present?
      documents.each do |a|
        doc = File.extname(a.document_file_name)
        file_path = Rails.root + "public/assets/tender/document/#{a.id}/original/"
        if doc == '.zip'
          @ids << a.id
          if File.exist?(a.document.path)
            Zip::File.open(a.document.path) {|zip_file|
              zip_file.each { |f|
                f_path = File.join(file_path,f.name)
                zip_file.extract(f,f_path) unless File.exist?(f_path)
              }
            }
            FileUtils.rm(a.document.path)

            TenderDocument.where(:id => a.id).update_all(:directory => 'unzip')
          end

        end
      end
    end

    if @ids.present? && @ids.size > 0
      @ids.each do |i|
        folder =  Rails.root + "public/assets/tender/document/#{i}/original/"
        dir = Dir.glob("#{folder}/**/*")

        if dir.present?
          dir.each do |d|

            file = File.basename(d)
            ext = File.extname(d)
            puts "File:#{d}"
            size = File.size(d)
            doc = TenderDocument.find(i)

            if ext != '.zip' && ext.present?
              unzip = UnzipFile.new
              unzip.path = d
              unzip.user_id = doc.user_id
              unzip.file_size = size
              unzip.filename = file
              unzip.tender_document_id = i
              unzip.extension = ext
              unzip.tender_id = params[:tender_id]
              path = File.dirname(d)
              base = File.basename(path)

              if base.to_s != 'original'
                unzip.directory = base
              end
              unzip.save
            end
          end
        end
      end
    end

    @unzips = UnzipFile.where(:user_id => session[:user_logged_id])
    @documents = TenderDocument.where(:user_id => session[:user_logged_id])
    urls = []
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @data = render :partial => 'tenders/documents'
  end

  def new_invite_form
    tender_id = params[:tender_id]
    @tender = Tender.find(tender_id)
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)

    @trade_array = []
    if @tender_trades.present?
      @tender_trades.each do |t|
        @trade_array << t.trade_id
      end
    end

    @trades = Trade.where(:id => @trade_array)
    @data = render :partial => 'tenders/new_invites'
  end

  def invite_sub_contractor
    tender_id  = params[:tender_id]
    names = params[:names]
    emails = params[:emails]
    trades = params[:trades]
    invite = params[:invite]

    if invite.present?
      TenderInvite.where(:tender_id => tender_id).destroy_all
    end

    if emails.present?
      emails.each_with_index do |n,index|
        if n.present? && trades[index].present?
          user = User.where(:email => emails[index]).first
          invite = TenderInvite.new
          invite.tender_id = tender_id
          invite.email = emails[index]
          invite.trade_id = trades[index]
          if user.present?
            invite.user_id = user.id
          end
          invite.save
        end

      end
    end

    redirect_to "/tenders/new_tender?reviews=true&info_id=#{tender_id}"
  end

  def get_documents
    @unzip_dirs = []
    @docs1 = []
    files = params[:out]
    directories = params[:directories].present? ? params[:directories].reject { |c| c.empty? } : nil
    tender_id = params[:tender_id]

    if directories.present?
      docs = TenderDocument.where(:tender_id => tender_id,:user_id => session[:user_logged_id],:status => nil)
      ids = []
      if docs.present?
        docs.each do |t|
          ids << t.id
        end
      end
    end


    if directories.present?
      puts "IDS-----------> SIZE:#{ids.size}"
      puts "files-----------> SIZE:#{files.size}"
      if params[:out].size == files.size
        puts "DIRECTORIES --------> #{directories}"
        directories.each_with_index do |d,i|
          puts "ID:#{ids[i]}"
          file_dir = TenderDocument.where(:directory => "#{d}").first
          #doc_file = TenderDocument.where("document_file_name = files[i] and  directory NOT LIKE '%Header%'").first
          if file_dir.present?
            TenderDocument.where(:id => ids[i],:tender_id => tender_id,:user_id => session[:user_logged_id]).update_all(:directory => d,:created_at => file_dir.created_at,:updated_at => file_dir.created_at,:status => 'modified')
          else
            puts "NOT PRESENT"
            TenderDocument.where(:id => ids[i],:tender_id => tender_id,:user_id => session[:user_logged_id]).update_all(:directory => d,:status => 'modified')
          end


        end
      end
    else
      TenderDocument.where(:tender_id => tender_id,:user_id => session[:user_logged_id]).update_all(:status => 'modified')
    end

    urls = []
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end

    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    if @unzips.present?
      @unzips.each do |a|
        @new_direcotires << a.directory
      end
    end

    @tender = Tender.find(tender_id)
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id).order('created_at desc,directory desc')
    puts "@documents------------> #{@documents.inspect}"
    @data = render :partial => 'tenders/documents'
  end

  def delete_documents
    id_array = params[:ids]
    ids = []
    @unzip_dirs = []
    @docs1 = []
    if id_array.present?
      id_array.each do |i|
        if i != 'on'
          ids << i
        end
      end
    end
    puts "ID:#{ids}"
    if ids.present?
       ids.each do |id|

         if id.to_i > 0
           begin
             tender = TenderDocument.find(id.to_i)
             TenderDocument.where(:id => tender.id).destroy_all
           rescue
             zip = UnzipFile.where(:id => id.to_i).first

             if zip.present?
               UnzipFile.where(:id => id.to_i).destroy_all
             else
               UnzipFile.where(:directory => id.to_s).destroy_all
             end
           end
         else
           unzip = UnzipFile.where(:path => id).first

           if unzip.present?
             if File.exist?(id)
               FileUtils.rm(id)
             end
             UnzipFile.where(:id => unzip.id).destroy_all

             folder =  Rails.root + "public/assets/tender/document/#{unzip.tender_document_id}/original/"
             dir = Dir.glob("#{folder}/**/*")
             if dir.present?
               ext_array = []
               dir.each do |d|
                 ext_array << File.extname(d)
               end
               exts = []
               exts = ext_array.reject { |c| c.empty? }
               if !exts.present?
                 deleted_folder =  Rails.root + "public/assets/tender/document/#{unzip.tender_document_id}"
                 FileUtils.rm_rf(deleted_folder)
               end
             end
           else
             TenderDocument.where(:directory => id).destroy_all
           end
         end
       end
    end

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => params[:tender_id]).order('created_at desc,directory desc')
    urls = []
    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => params[:tender_id])

    if @unzips.present?
      @unzips.each do |a|
        @new_direcotires << a.directory
      end
    end
    @tender = Tender.find(params[:tender_id])
    #@data = render :partial => 'tenders/documents'
    @data = render :partial => 'tenders/document_upload/new_ducument_table'
  end


  def add_directory

    doc = TenderDocument.where(:tender_id => params[:tender_id],:directory => '0')

    if !doc.present?
      document = TenderDocument.new
      document.tender_id = params[:tender_id]
      document.directory = '0'
      document.user_id = session[:user_logged_id]
      document.save
    end

    @tender = Tender.find(params[:tender_id])
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => params[:tender_id]).order('created_at desc,directory desc')
    @data = render :partial => 'tenders/document_upload/new_ducument_table'
  end

  def update_folder_list
    tender_id = params[:tender_id]
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
        end
      end
    end
    # @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    # @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)
    #
    # if @unzips.present?
    #   @unzips.each do |u|
    #     @new_direcotires << u.directory
    #   end
    # end
    render :json => { :state => 'valid',:directories => @directories.uniq}
  end


  def check_document_cnt
    tender_id = params[:tender_id]
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id).order('created_at desc,directory desc')

    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    if @unzips.present?
      @unzips.each do |u|
        @new_direcotires << u.directory
      end
    end
    render :json => { :state => 'valid',:directories => @new_direcotires.uniq}
  end

  def new_folder
    name = params[:new_folder]
    tender_id =params[:tender_id]
    document = TenderDocument.new
    @unzip_dirs = []
    @docs1 = []
    document.user_id = session[:user_logged_id]
    document.directory = name
    document.tender_id = tender_id
    document.save

    dir = "#{Rails.root}/public/assets/tender/document/#{document.id}"
    Dir.mkdir(dir) unless File.exists?(dir)

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id)
    urls = []
    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
          urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)

    if @unzips.present?
      @unzips.each do |u|
        @new_direcotires << u.directory
      end
    end

    @tender = Tender.find(tender_id)
    @data = render :partial => 'tenders/documents'
  end


  def move_files
    ids = params[:ids].split(",")
    new_folder_name = params[:new_folder_name]
    directory = params[:directory]
    tender_id = params[:tender_id]
    @unzip_dirs = []
    @docs1 = []
    if new_folder_name.present?
      document = TenderDocument.new

      document.user_id = session[:user_logged_id]
      document.directory = new_folder_name
      document.save

      dir = "#{Rails.root}/public/assets/tender/document/#{document.id}"

      Dir.mkdir(dir) unless File.exists?(dir)

      ids.each do |a|
        begin
          tender_doc = TenderDocument.find(a)
          if tender_doc.present?
            TenderDocument.where(:id => a).update_all(:directory => new_folder_name,:created_at => document.created_at,:updated_at => document.created_at)
          end
        rescue
          #UnzipFile.where(:id => a).update_all(:directory => new_folder_name)
        end
      end

    else
      dir = TenderDocument.where(:directory => "#{directory}").last
      ids.each do |a|
        begin
          tender_doc = TenderDocument.find(a)
          if tender_doc.present?

            TenderDocument.where(:id => a).update_all(:directory => directory,:created_at => dir.created_at,:updated_at => dir.created_at)
          end
        rescue
          #UnzipFile.where(:path => a).update_all(:directory => directory)
        end
      end
    end

    @documents = TenderDocument.where(:tender_id => tender_id,:user_id => session[:user_logged_id]).order('created_at desc,directory desc')
    urls = []
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
        end
      end
    end
    # @unzips = UnzipFile.where(:tender_id => tender_id)
    # @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    #
    # if @unzips.present?
    #   @unzips.each do |a|
    #     @new_direcotires << a.directory
    #   end
    # end

    @tender = Tender.find(tender_id)
    # Original render
    #@data = render :partial => 'tenders/documents'

    @data = render :partial => 'tenders/document_upload/new_added_folder'
  end

  def rename_file
    tender_id = params[:tender_id]
    id = params[:id]
    name = params[:new_value]
    old_name = params[:old_value]
    tender_id = params[:tender_id]
    @unzip_dirs = []
    @docs1 = []
    @docs = []
    documents = TenderDocument.where(:directory => old_name.strip,:tender_id => tender_id)

    if documents.present?
      TenderDocument.where(:directory => old_name,:tender_id =>tender_id).update_all(:directory => name.strip)
    else
      #unzip = UnzipFile.where(:directory => id,:tender_id =>tender_id)
      #if unzip.present?
        #UnzipFile.where(:directory => id,:tender_id =>tender_id).update_all(:directory => name)
      #end
    end

    urls = []
    @directories = []

    # if @documents.present?
    #   @documents.each do |u|
    #     if u.directory != 'unzip'
    #       @directories << u.directory
    #       urls << request.host_with_port+"/assets/tender/document/#{u.id}/original/#{u.document_file_name}"
    #     end
    #   end
    # end
    # @unzips = UnzipFile.where(:user_id => session[:user_logged_id],:tender_id => tender_id)
    # @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    #
    # if @unzips.present?
    #   @unzips.each do |a|
    #     @new_direcotires << a.directory
    #   end
    # end
    @tender = Tender.find(tender_id)
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id =>tender_id).order('created_at desc,directory desc')
    puts "@documents-------------> #{@documents.inspect}"
    # Old render
    #@data = render :partial => 'tenders/documents'
    @data = render :partial => 'tenders/document_upload/new_added_folder'
  end

  def create
    @tender = Tender.new(tender_permitted_params)
    if @tender.save
      redirect_to tenders_path
    else
      render :new
    end
  end

  def edit
    @tender = Tender.find(params[:id])
    @tender.document_file_name
    file_path = @tender.document.path
    puts file_path.gsub(@tender.document_file_name, "")
    file = File.open(File.expand_path(file_path.gsub(@tender.document_file_name, "")), 'r')
    puts Dir.glob("#{file_path.gsub(@tender.document_file_name)}").inspect
  end


  def edit_details
    @tender = Tender.find(params[:id])
    @categories = Category.all
    @values = TenderValue.all
  end

  def update
    @tender = Tender.find(params[:id])
  end

  def destroy

  end

  def search_document_package
    tender_id = params[:tender_id]
    trade_id  = params[:trade_id]

    tender_package = TenderPackage.where(:tender_id => tender_id,:trade_id => trade_id)

    if tender_package.present?

      packages = Package.where(:tender_id => tender_id)
      trades = []
      if packages.present?
        packages.each do |p|
          if p.code.include? "#{trade_id}"
            trades << p.id
          end
        end

        if trades.present?
          render :json => { :state => 'invalid',:cnt => trades.size,:trade_id => trade_id}
        else
          render :json => { :state => 'valid'}
        end
      end
    else
      render :json => { :state => 'valid'}
    end
  end

  def update_package_trades
    tender_id = params[:tender_id]
    ids  = params[:ids]
    trade_names = []
    TenderPackage.where(:tender_id => tender_id).destroy_all

    if ids.present?
      ids.each do |i|
        t_package = TenderPackage.new
        t_package.tender_id = tender_id
        t_package.trade_id = i

        trade = Trade.find(i)
        trade_names << trade.name
        t_package.category_id = trade.trade_category_id
        t_package.save
      end
    end

    document_package = DocumentPackage.where(:tender_id => tender_id)
    documents = []
    d_trade_names = []
    if document_package.present?
      document_package.each do |a|
        if !trade_names.include? "#{File.basename(a.path)}"
          documents << a.id
          d_trade_names << File.basename(a.path)
          FileUtils.rm_rf(a.path)
          FileUtils.rm_rf("#{a.path}.zip")
          DocumentPackage.where(:id => a.id).destroy_all
        end
      end
    end

    package_array = []
    if documents.present?
      documents.each_with_index do |a,index|
        trade = Trade.where(:name => d_trade_names[index]).first

        if trade.present?
          packages = Package.where(:tender_id => tender_id)

          if packages.present?
            packages.each do |p|
              if p.code.include? "#{trade.id}"
                Package.where(:id => p.id).destroy_all
              end
            end
          end
        end
      end
    end

    render :json => { :state => 'valid'}
  end

  def document_matrix

  end

  def get_latest_chat
    tender_id = params[:tender_id]
    @tender = Tender.find(tender_id)
    @user_array = []
    @user_array01 = []
    @trade_requests = []
    if session[:role] == 'Head Contractor'
      @approved_quotes = TenderApprovedTrade.where(:tender_id => tender_id,:hc_id => session[:user_logged_id])
    else
      @approved_quotes = TenderApprovedTrade.where(:tender_id => tender_id,:sc_id => session[:user_logged_id])
    end

    if @approved_quotes.present?
      @approved_quotes.each do |t|
        @trade_requests << t.trade_id
      end
    end

    @group_approved_trades = TenderApprovedTrade.where(:tender_id => tender_id,:trade_id => @trade_requests)
    @group_name = []

    if session[:role] == 'Head Contractor'
      @messages = Message.where(:tender_id => tender_id,:hc_id => session[:user_logged_id])
    else
      @messages = Message.where(:tender_id => tender_id,:sc_id => session[:user_logged_id])
    end

    @onlines = []
    @offlines = []
    @message_chats = MessageChat.where(:tender_id => tender_id,:to_id => session[:user_logged_id])
    @data = render :partial => 'tenders/tender_chat'
  end

  def get_latest_sub
    @tender = Tender.find(params[:tender_id])
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)
    @tender_requesting = TenderRequestQuote.where("tender_id = #{@tender.id} and status is null")
    @tendering = TenderRequestQuote.where("tender_id = #{@tender.id} and request_date is not null")
    @quote_array = []
    @trades_ids = []
    # if @tender_request_quotes.present?
    #   @tender_request_quotes.each do |a|
    #     @quote_array << a.id
    #   end
    # end
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)

    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades_ids << t.trade_id
      end
    end

    #@tender_trade_requests = TenderRequestTrade.where(:tender_request_quote_id => @quote_array.uniq)
    @tender_invites = TenderInvite.where(:tender_id => @tender.id).order('trade_id asc')

    # @tender_trade_array = []
    # if @tender_trade_requests.present?
    #   @tender_trade_requests.each do |t|
    #     @tender_trade_array << t.trade_id
    #   end
    # end
    # @invite_array = []
    # @invite_trade_array = []
    @data = render :partial => 'tenders/sub_contractors_quotes'
  end

  def get_latest_quote
    @tender = Tender.find(params[:tender_id])
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)

    @quote_array = []
    @trades_ids = []
    if @tender_request_quotes.present?
      @tender_request_quotes.each do |a|
        @quote_array << a.id
      end
    end
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)

    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades_ids << t.trade_id
      end
    end

    @tender_trade_requests = TenderRequestTrade.where(:tender_request_quote_id => @quote_array.uniq)
    @tender_invites = TenderInvite.where(:tender_id => @tender.id)

    @tender_trade_array = []
    if @tender_trade_requests.present?
      @tender_trade_requests.each do |t|
        @tender_trade_array << t.trade_id
      end
    end
    @invite_array = []
    @invite_trade_array = []
    @data = render :partial => 'tenders/quoting'
  end

  def get_document_control_per_sc
    # @tender = Tender.find(params[:tender_id])
    # @tender_approved = TenderApprovedTrade.where(:tender_id => @tender.id)
    #
    # @trades_approved = []
    # if @tender_approved.present?
    #   @tender_approved.each do |t|
    #     trade = Trade.find(t.trade_id)
    #     @trades_approved << trade.name
    #   end
    # end
    #
    # @data = render :partial => 'tenders/document_upload/get_document_control'
    @tender = Tender.find(params[:tender_id])
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)
    @documents = TenderDocument.where(:tender_id => @tender.id)
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)
    @tender_approved = TenderApprovedTrade.where(:tender_id => @tender.id,:status => 'approved')

    @trades_approved = []
    if @tender_approved.present?
      @tender_approved.each do |t|
        trade = Trade.find(t.trade_id)
        @trades_approved << trade.id
      end
    end

    @trades = []

    if @tender_trades.present?
      @tender_trades.each do |t|
        #if @trades_approved.include? t.trade_id
          @trades << t.trade_id
        #end
      end
    end
    @data = render :partial => 'tenders/document_control'
  end

  def hc_tender
    @tender = Tender.find(params[:id])
    @trade_categories = TradeCategory.all
    @unzip_dirs = []
    @trade_requests = []
    @docs1 = []
    @invite_array = []
    @invite_trade_array = []
    @user_array = []
    @user_array01 = []
    @group_name = []
    @onlines = []
    @offlines = []
    @ip = request.host_with_port
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)
    @approved_quotes = TenderApprovedTrade.where(:tender_id => @tender.id,:hc_id => session[:user_logged_id])
    @tender_invites = TenderInvite.where(:tender_id => @tender.id)
    @tender_invite_count = TenderInvite.where(:tender_id => @tender.id).count()
    @addendas = Addenda.where(:tender_id => @tender.id,:status => 'completed')
    @tender_document = TenderDocument.new
    if @approved_quotes.present?
      @approved_quotes.each do |t|
        @trade_requests << t.trade_id
      end
    end

    @quote_array = []
    if @tender_request_quotes.present?
      @tender_request_quotes.each do |a|
        @quote_array << a.id
      end
    end

    @messages = Message.where(:tender_id => @tender.id)
    @tender_trade_requests = TenderRequestTrade.where(:tender_request_quote_id => @quote_array.uniq)

    @tender_trade_array = []
    if @tender_trade_requests.present?
      @tender_trade_requests.each do |t|
        @tender_trade_array << t.trade_id
      end
    end

    @trades = []

    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades << t.trade_id
      end
    end
  end

  def get_document_control
    @tender = Tender.find(params[:tender_id])
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)

    @trades = []

    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades << t.trade_id
      end
    end
    @data = render :partial => 'tenders/document_control'
  end

  def sc_tender
    @tender = Tender.find(params[:id])
    @trade_categories = TradeCategory.all
    @unzip_dirs = []
    @docs1 = []

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)
    @tender_trades = TenderTrade.where(:tender_id => @tender.id)
    @tender_request_quotes = TenderRequestQuote.where(:tender_id => @tender.id)
    @approved_quotes = TenderApprovedTrade.where(:tender_id => @tender.id,:sc_id => session[:user_logged_id])

    @trades = []


    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades << t.trade_id
      end
    end

    @directories = []
    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
        end
      end
    end

    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @unzips = UnzipFile.where(:user_id => session[:user_logged_id])

    if @unzips.present?
      @unzips.each do |u|
        @new_direcotires << u.directory
      end
    end
  end

  def get_tender_modal
    @tender = Tender.find(params[:id])
    @trade_categories = TradeCategory.all
    @data = render :partial => 'tenders/tender_modal'
  end

  def search_quotes_by_trades
    tender_id = params[:tender_id]
    @search = params[:search]
    no_quote = params[:no_quote]
    @tender = Tender.find(tender_id)

    @trades_ids = []
    if no_quote.present?
      @tender_trades = TenderTrade.where(:tender_id => @tender.id)
      if @tender_trades.present?
        @tender_trades.each do |t|
          @trades_ids << t.trade_id
        end
      end
      @data = render :partial => 'tenders/approved_trade_quotes'
    else
      invites = TenderInvite.where("(name LIKE '%#{@search}%' OR email LIKE '%#{@search}%') AND tender_id=#{@tender.id}")
      invite_array = []
      if invites.present?
        invites.each do |i|
          invite_array << i.trade_id
        end
      end
      @tender_trades = TenderTrade.where(:tender_id => @tender.id)

      if @tender_trades.present?
        @tender_trades.each do |t|
          @trades_ids << t.trade_id
        end
      end
      @trades_ids.concat(invite_array)
      @data = render :partial => 'tenders/search_by_quotes'
    end
  end

  def filter_by_trades
    tender_id = params[:tender_id]
    trades = params[:trades]
    tab = params[:tab]
    @tender = Tender.find(tender_id)
    @trades_ids = []

    if trades.present?
      trades.each do |t|
        @trades_ids << t.to_i
      end
    end

    if tab == 'invites'
      @tender_invites = TenderInvite.where(:tender_id => tender_id,:trade_id => @trades_ids)
      @data = render :partial => 'tenders/sub_contractors_tab/invited_user_tender'
    elsif tab == 'request'
      @tender_request_quotes = TenderRequestQuote.where(:tender_id => tender_id, :trade_id => @trades_ids)
      @data = render :partial => 'tenders/sub_contractors_tab/requesting_tender'
    elsif tab == 'tendering'
      @tendering = TenderRequestQuote.where(:tender_id => tender_id,:trade_id => @trades_ids).where("request_date is not null")
      @data = render :partial => 'tenders/sub_contractors_tab/tendering'
    end
  end

  def sub_contractor_tabs
    tender_id = params[:tender_id]
    @trades_array = params[:trade_ids]


    @tender = Tender.where(:id => tender_id).first
    tab = params[:tab]
    if tab == 'invites'
      @tender_invites = TenderInvite.where(:tender_id => tender_id)
      @data = render :partial => 'tenders/sub_contractors_tab/invited_user_tender'
    elsif tab == 'request'
      @tender_request_quotes = TenderRequestQuote.where("tender_id = #{tender_id} and (status is not null AND status != 'declined')")
      @tender_requesting = TenderRequestQuote.where("tender_id = #{tender_id} and status is null")
      @data = render :partial => 'tenders/sub_contractors_tab/requesting_tender'
    elsif tab == 'tendering'
      @tendering = TenderRequestQuote.where(:tender_id => tender_id).where("declined_date is null and request_date is not null")
      @data = render :partial => 'tenders/sub_contractors_tab/tendering'
    end
  end

  def filter_by_status
    tender_id = params[:tender_id]
    @status = params[:status]
    @tender = Tender.find(tender_id)
    @trades_ids = []

    @tender_trades = TenderTrade.where(:tender_id => @tender.id)

    if @tender_trades.present?
      @tender_trades.each do |t|
        @trades_ids << t.trade_id
      end
    end

    if @status.include? 'all'
      @data = render :partial => 'tenders/approved_trade_quotes'
    else
      @data = render :partial => 'tenders/search_by_status'
    end
  end

  def approved_trade_quote
    quote_id = params[:quote_id]
    tender_id = params[:tender_id]
    trade_id = params[:trade_id]
    sc_id = params[:sc_id]
    @tender = Tender.find(tender_id)
    quote = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => sc_id).first

    if quote.id.present?
      approved = TenderApprovedTrade.new
      approved.tender_id = tender_id
      approved.sc_id = quote.sc_id
      approved.hc_id = quote.hc_id
      approved.trade_id = trade_id
      approved.status = 'approved'
      approved.tender_request_quote_id = quote.id
      if approved.save
        @trades_ids = []

        @tender_trades = TenderTrade.where(:tender_id => @tender.id)

        if @tender_trades.present?
          @tender_trades.each do |t|
            @trades_ids << t.trade_id
          end
        end

        @data = render :partial => 'tenders/approved_trade_quotes'
      else
        render :json => { :state => 'invalid'}
      end
    else
      render :json => { :state => 'valid'}
    end
  end

  def reject_trade_quotes
    quote_id = params[:quote_id]
    tender_id = params[:tender_id]
    trade_id = params[:trade_id]
    sc_id = params[:sc_id]
    @tender = Tender.find(tender_id)
    quote = TenderRequestQuote.where(:tender_id => tender_id,:sc_id => sc_id).first

    if quote.id.present?
      approved = TenderApprovedTrade.new
      approved.tender_id = tender_id
      approved.sc_id = quote.sc_id
      approved.hc_id = quote.hc_id
      approved.trade_id = trade_id
      approved.status = 'declined'
      approved.tender_request_quote_id = quote.id
      if approved.save
        @trades_ids = []
        @tender_trades = TenderTrade.where(:tender_id => @tender.id)

        if @tender_trades.present?
          @tender_trades.each do |t|
            @trades_ids << t.trade_id
          end
        end
        @data = render :partial => 'tenders/approved_trade_quotes'
      else
        render :json => { :state => 'invalid'}
      end
    else
      render :json => { :state => 'valid'}
    end
    #TenderconMailer.delay.tender_trade_email_rejected(user.email,user.first_name,trade.name)
  end

  def tender_new_sub

  end

  def approved_tender_request
    tender_id = params[:tender_id]
    id = params[:id]
    label = params[:label].strip

    tender_request_quote = TenderRequestQuote.where(:id => id,:tender_id => tender_id).first

    if tender_request_quote.present?
      approved = TenderApprovedTrade.new
      approved.tender_id = tender_id
      approved.sc_id = tender_request_quote.sc_id
      approved.hc_id = tender_request_quote.hc_id
      approved.trade_id = tender_request_quote.trade_id
      if label == 'Approve'
        approved.status = 'approved'
      else
        approved.status = 'declined'
      end
      approved.tender_request_quote_id = tender_request_quote.id
      approved.save

      if approved.status == 'approved'
        TenderRequestQuote.where(:id => tender_request_quote.id).update_all(:status => approved.status,:approved_date => Time.now,:declined_date => nil)
      elsif approved.status == 'declined'
        TenderRequestQuote.where(:id => tender_request_quote.id).update_all(:status => approved.status,:declined_date => Time.now,:approved_date => nil)
      end

      @tender_requesting = TenderRequestQuote.where("tender_id = #{tender_id} and (status is null)")
      @tender_request_quotes = TenderRequestQuote.where("tender_id = #{tender_id} and (status is not null AND status != 'declined')")
      @data = render :partial => 'tenders/sub_contractors_tab/requesting_tender'
    end
  end

  def invite_more_sub
    tender_id = params[:tender_id]
    @tender = Tender.find(tender_id)
    names = params[:names]
    emails = params[:emails]
    trades = params[:trades]
    companies = params[:companies]

    if tender_id.present?
      emails.each_with_index do |e,index|
        user = User.where(:email => e).first

        tender_invite = TenderInvite.where(:email => e,:trade_id => trades[index]).first

        if !tender_invite.present?
          invite = TenderInvite.new
          invite.tender_id = @tender.id
          invite.email = e
          invite.name = names[index]
          invite.trade_id = trades[index]
          invite.trade_id = trades[index]
          invite.company = companies[index]
          invite.email_sent = Time.now
          if user.present?
            invite.user_id = user.id
          end
          invite.save

          t = Trade.find(trades[index])
          if user.present?
            decline_path = "http://"+request.host_with_port+"/invites/decline_tender_invite?tender_id=#{@tender.id}&email=#{e}&trade=#{t.id}"
            path = "http://"+request.host_with_port+"/users/login?email=#{user.email}&tender=#{@tender.id}&trade=#{t.id}"
          else
            decline_path = "http://"+request.host_with_port+"/invites/decline_tender_invite?tender_id=#{@tender.id}&email=#{e}&trade=#{t.id}"
            path = "http://"+request.host_with_port+"/users/register?name=#{names[index]}&email=#{e}&tender=#{@tender.id}&trade=#{t.id}"
          end
          TenderconMailer.delay.sent_sc_invites(e,names[index],t.name,path,decline_path)
        end

      end

      @tender_invites = TenderInvite.where(:tender_id => @tender.id)
      @data = render :partial => 'tenders/sub_contractors_tab/invited_user_tender'
    end
  end


  def get_tender_body
    @trade_categories = TradeCategory.all
    @tender = Tender.find(params[:tender_id])
    @invite_count = TenderInvite.where(:tender_id => params[:tender_id],:email => session[:email],:status => nil).count()
    @data = render :partial => 'tenders/tender_body'
  end


  private

  def tender_permitted_params
    params.require(:tender).permit(:id,:title,:description,:address,:state,:postcode,:suburb,:address_terms,
                                   :client,:category_id,:architect,:tender_value_id,:tendercon_id)
  end

  def tender_document_premitted_params
    params.require(:tender_document).permit(:id,:user_id,:document,:tender_id,:directory)
  end
end