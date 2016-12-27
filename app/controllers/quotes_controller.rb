class QuotesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get_latest_quotes
    @tender = Tender.find(params[:tender_id])
    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new
    if session[:role] == 'Head Contractor'
      @quotes = Quote.where(:tender_id => @tender.id)
      puts "QUOTES:#{@quotes.inspect}"
      if @quotes.present?
        @refs = []
        @quotes.each do |a|
          @refs << a.ref_no
        end
        puts "------------> #{@refs.inspect}"
      end
    elsif session[:role] == 'Sub Contractor'
      @quotes = Quote.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)

      if @quotes.present?
        @refs = []
        @quotes.each do |a|

          @refs << a.ref_no
        end
        puts "------------> #{@refs.inspect}"
      end
    end

    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name

      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"

    end

    quote = Quote.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if quote.present?
      str = quote.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "Q-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "Q-#{result.upcase}-1"
    end
    puts "USER:#{@sc_user.company}"

    if session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_approved_trades = TenderApprovedTrade.where(:sc_id => session[:user_logged_id],:tender_id => @tender.id)
    else
      tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id],:tender_id => @tender.id)
    end

    trade_array = []
    if tender_approved_trades.present?
      tender_approved_trades.each do |t|
        trade_array << t.trade_id
      end
    end

    @trades = Trade.where(:id => trade_array)

    @primary_trades = PrimaryTrade.all
    @trade_array = []

    if @primary_trades.present?
      @primary_trades.each do |a|
        @trade_array << a.trade_id
      end
    end

    @data = render :partial => 'quotes/latest_quotes'

  end

  def get_new_ref
    @sc_user = User.find(session[:user_logged_id])
    rfi = Quote.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if rfi.present?
      str = rfi.ref_no
      last_str = str.split('-')[-1]
      @ref_no = "Q-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "Q-#{result.upcase}-1"
    end

    render :json => { :state => 'valid',:ref => @ref_no}
  end

  def save_quotes
    tender_id = params[:tender_id]
    ref_no = params[:ref_no]
    to = params[:to]
    attention = params[:attention]
    date = params[:quote_date]
    title = params[:title]
    quote_desc = params[:quote_desc]
    price = params[:price]
    trades = params[:trades]

     if title.present? && trades.present? &&  price.present?
       quote_document = QuoteDocument.where(:tender_id => tender_id, :user_id => session[:user_logged_id],:quote_id => nil).first

       if quote_document.present?
         trades.each do |a|
           quote_data = Quote.new
           quote_data.ref_no = ref_no
           quote_data.user_id = session[:user_logged_id]
           quote_data.to = to
           quote_data.attention = attention
           quote_data.quote_date = date
           quote_data.description = quote_desc
           quote_data.trade_id = a
           quote_data.tender_id = tender_id
           quote_data.price = price.to_f
           quote_data.title = title
           quote_data.status = 'Active'

           if quote_data.save
             QuoteDocument.where(:tender_id => tender_id, :user_id => session[:user_logged_id],:quote_id => nil).update_all(:quote_id => quote_data.id)
             QuoteDocumentOptional.where(:tender_id => tender_id, :user_id => session[:user_logged_id],:quote_id => nil).update_all(:quote_id => quote_data.id)
             @tender = Tender.find(tender_id)
             quote_notif = QuoteNotification.new
             quote_notif.sc_id = session[:user_logged_id]
             quote_notif.hc_id = @tender.user_id
             quote_notif.quote_id = quote_data.id
             quote_notif.message = "New Quote"
             quote_notif.tender_id = tender_id
             quote_notif.seen = 0
             quote_notif.save
           end
         end
         render :json => {:state => 'valid'}
       else
         render :json => {:state => 'invalid'}
       end

     else
       render :json => {:state => 'invalid'}
     end

  end

  def download_quotes
    require 'zip'
    tender = Tender.find(params[:tender_id])
    project_name = "#{tender.tendercon_id}-#{tender.title}"
    dir = "#{Rails.root}/public/assets/quotes/#{project_name}"
    Dir.mkdir(dir) unless File.exists?(dir)
    ids = params[:ids]
    quote_id = params[:quote_id]

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name
      @avatar_path = a.image.path
      puts "@avatar_filename:#{a.image.url}"
      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
    end

    if quote_id.present?
      quote = Quote.find(quote_id)
      trade = Trade.find(quote.trade_id)
      hc_user = User.find(tender.user_id)
      puts "hc_user:#{hc_user.first_name}"
      dir1 = "#{Rails.root}/public/assets/quotes/#{project_name}/#{quote.ref_no}"
      Dir.mkdir(dir1) unless File.exists?(dir1)

      Quote.quote_link(quote,hc_user,trade,project_name,@avatar_path)

      if quote.quote_documents.present?
        quote.quote_documents.each do |a|
          puts "a.document.url:#{a.document.path}"
          if File.exist? a.document.path
            FileUtils.cp a.document.path, dir1
          end
        end
      end

      if quote.quote_document_optionals.present?
        quote.quote_document_optionals.each do |a|
          puts "a.document.url:#{a.document.path}"
          if File.exist? a.document.path
            FileUtils.cp a.document.path, dir1
          end
        end
      end
    end

    if ids.present?
      ids.each do |a|
        if a != 'on'
          quote = Quote.where(:ref_no => a).first
          trade = Trade.find(quote.trade_id)
          hc_user = User.find(tender.user_id)
          puts "hc_user:#{hc_user.first_name}"
          #dir1 = "#{Rails.root}/public/assets/quotes/#{project_name}/#{quote.ref_no}"
          #Dir.mkdir(dir1) unless File.exists?(dir1)

          dir1 = "#{Rails.root}/public/assets/quotes/#{project_name}/#{quote.ref_no}"
          FileUtils.makedirs(dir)

          if File.exist?(@avatar_path)
            Quote.quote_link(quote,hc_user,trade,project_name,@avatar_path)
          else
            Quote.quote_link(quote,hc_user,trade,project_name,nil)
          end


          if quote.quote_documents.present?
            quote.quote_documents.each do |a|
              puts "a.document.url:#{a.document.path}"
              if File.exist? a.document.path
                FileUtils.cp a.document.path, dir1
              end
            end
          end

          if quote.quote_document_optionals.present?
            quote.quote_document_optionals.each do |a|
              puts "a.document.url:#{a.document.path}"
              if File.exist? a.document.path
                FileUtils.cp a.document.path, dir1
              end
            end
          end
        end
      end
    end

    @destination =  "#{Rails.root}/public/assets/quotes/#{project_name}"

    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    new_destination =  "#{Rails.root}/public/assets/quotes/"
    old_folder = "#{Rails.root}/public/assets/quotes/#{project_name}/#{project_name}.zip"
    FileUtils.cp old_folder, new_destination
    if !quote_id.present?
      FileUtils.rm_rf("#{Rails.root}/public/assets/quotes/#{project_name}/")

    end


    if quote_id.present?

      link = "http://#{request.host_with_port}/assets/quotes/#{project_name}/#{quote.ref_no}.pdf"
      puts "---------->link:#{link}"
      render :json => { :state => 'valid',:link => link}
    elsif ids.present?
      link = "http://#{request.host_with_port}/assets/quotes/#{project_name}.zip"
      render :json => { :state => 'valid',:link => link}
    end

  end

  def delete_quotes
    ids = params[:ids]

    if ids.present?
      ids.each do |id|
        if id != 'on'
          Quote.where(:ref_no => id).update_all(:status => 'Deleted')
        end
      end
    end

    get_quotes

  end

  def delete_quote
    Quote.where(:id => params[:id]).update_all(:status => 'Deleted')

    redirect_to :back
  end

  def view
    require 'zip'
    ref_no = params[:ref_no]
    @tender = Tender.find(params[:tender_id])
    @quote = Quote.where(:ref_no => ref_no,:tender_id => @tender.id).first
    project_name = "#{@tender.tendercon_id}-#{@tender.title}"
    if File.directory? "#{Rails.root}/public/assets/quotes/#{project_name}"
      puts "EXIST"
      FileUtils.rm_rf("#{Rails.root}/public/assets/quotes/#{project_name}")
    end
    dir = "#{Rails.root}/public/assets/quotes/#{project_name}"
    FileUtils.makedirs(dir)

    #Dir.mkdir(dir) unless File.exists?(dir)
    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    if params[:notif].present?
     QuoteNotification.where(:tender_id => @tender.id,:quote_id => @quote).update_all(:updated_at => Time.now.strftime("%Y-%m-%d %H:%M:%S"),:seen => 1)
    end

    @sc_user = User.find(session[:user_logged_id])
    @sc_user.company_avatars.each do |a|
      if a.image_file_name.present?
        @avatar_filename = a.image_file_name
        @avatar_path = a.image.path
        @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
      end
    end

    trade = Trade.find(@quote.trade_id)
    hc_user = User.find(@tender.user_id)
    dir1 = "#{Rails.root}/public/assets/quotes/#{project_name}/#{@quote.ref_no}"
    Dir.mkdir(dir1) unless File.exists?(dir1)

    if @avatar_path.present?
      if File.exist?(@avatar_path)
        puts "PRESENT ========> "
        Quote.quote_link(@quote,hc_user,trade,project_name,@avatar_path)
      else
        puts "ELSE ========> "
        Quote.quote_link(@quote,hc_user,trade,project_name,nil)
      end
    else
      Quote.quote_link(@quote,hc_user,trade,project_name,nil)
    end



    if @quote.quote_documents.present?
      @quote.quote_documents.each do |a|
        puts "a.document.url:#{a.document.path}"
        if File.exist? a.document.path
          FileUtils.cp a.document.path, dir1
        end
      end
    end

    if @quote.quote_document_optionals.present?
      @quote.quote_document_optionals.each do |a|
        puts "a.document.url:#{a.document.path}"
        if File.exist? a.document.path
          FileUtils.cp a.document.path, dir1
        end
      end
    end

    @destination =  "#{Rails.root}/public/assets/quotes/#{project_name}"

    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    new_destination =  "#{Rails.root}/public/assets/quotes/"
    old_folder = "#{Rails.root}/public/assets/quotes/#{project_name}/#{project_name}.zip"
    FileUtils.cp old_folder, new_destination

    @pdf_link = "http://#{request.host_with_port}/assets/quotes/#{project_name}/#{@quote.ref_no}.pdf"

  end

  def update_quote
    @quote = Quote.find(params[:quote_id])

    if @quote.present?
      @quote.update_attributes({:status => "Deleted"})
    end
    redirect_to :back
  end


  def search_by_trade
    @tender = Tender.find(params[:tender_id])

    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new
    if session[:role] == 'Head Contractor'
      if params[:trade_id].to_i > 0
        @quotes = Quote.where(:tender_id => @tender.id,:trade_id => params[:trade_id])
      else
        @quotes = Quote.where(:tender_id => @tender.id)
      end

      puts "QUOTES:#{@quotes.inspect}"
      if @quotes.present?
        @refs = []
        @quotes.each do |a|
          @refs << a.ref_no
        end
        puts "------------> #{@refs.inspect}"
      end
    elsif session[:role] == 'Sub Contractor'
      if params[:trade_id].to_i > 0
        @quotes = Quote.where(:tender_id => @tender.id,:trade_id => params[:trade_id])
      else
        @quotes = Quote.where(:tender_id => @tender.id)
      end


      if @quotes.present?
        @refs = []
        @quotes.each do |a|

          @refs << a.ref_no
        end
        puts "------------> #{@refs.inspect}"
      end
    end

    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name

      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"

    end

    quote = Quote.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if quote.present?
      str = quote.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "Q-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "Q-#{result.upcase}-1"
    end
    puts "USER:#{@sc_user.company}"

    if session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_approved_trades = TenderApprovedTrade.where(:sc_id => session[:user_logged_id],:tender_id => @tender.id)
    else
      tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id],:tender_id => @tender.id)
    end

    trade_array = []
    if tender_approved_trades.present?
      tender_approved_trades.each do |t|
        trade_array << t.trade_id
      end
    end

    @trades = Trade.where(:id => trade_array)

    @primary_trades = PrimaryTrade.all
    @trade_array = []

    if @primary_trades.present?
      @primary_trades.each do |a|
        @trade_array << a.trade_id
      end
    end

    @data = render :partial => 'quotes/search_by_trade'
  end


  private

  def get_quotes
    @tender = Tender.find(params[:tender_id])
    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new
    if session[:role] == 'Head Contractor'
      @quotes = Quote.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)
    elsif session[:role] == 'Sub Contractor'
      @quotes = Quote.where(:user_id => session[:user_logged_id],:tender_id => @tender.id)

      if @quotes.present?
        @refs = []
        @quotes.each do |a|
          @refs << a.ref_no
        end
        puts "------------> #{@refs.inspect}"
      end
    end

    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name

      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"

    end

    quote = Quote.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if quote.present?
      str = quote.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "Q-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "Q-#{result.upcase}-1"
    end
    puts "USER:#{@sc_user.company}"

    if session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_approved_trades = TenderApprovedTrade.where(:sc_id => session[:user_logged_id],:tender_id => @tender.id)
    else
      tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id],:tender_id => @tender.id)
    end

    trade_array = []
    if tender_approved_trades.present?
      tender_approved_trades.each do |t|
        trade_array << t.trade_id
      end
    end

    @trades = Trade.where(:id => trade_array)

    @primary_trades = PrimaryTrade.all
    @trade_array = []

    if @primary_trades.present?
      @primary_trades.each do |a|
        @trade_array << a.trade_id
      end
    end

    @data = render :partial => 'quotes/latest_quotes'
  end



end