class RfisController < ApplicationController
  skip_before_action :verify_authenticity_token
  def get_latest_rfis
    @tender = Tender.find(params[:tender_id])

    if session[:role] == 'Head Contractor'
      @rfis = Rfi.where(:tender_id => @tender.id)
    elsif session[:role] == 'Sub Contractor'
      @rfis = Rfi.where(:tender_id => @tender.id,:user_id => session[:user_logged_id])
    end

    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name

      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
      puts "LINK:#{@link}"
    end

    rfi = Rfi.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if rfi.present?
      str = rfi.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "RFI-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "RFI-#{result.upcase}-1"
    end
    puts "USER:#{@sc_user.company}"

    if session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_approved_trades = TenderApprovedTrade.where(:sc_id => session[:user_logged_id],:tender_id => params[:tender_id])
    else
      tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id],:tender_id => params[:tender_id])
    end

    trade_array = []
    if tender_approved_trades.present?
      tender_approved_trades.each do |t|
        trade_array << t.trade_id
      end
    end
    @rfi_document = RfiDocument.new
    @trades = Trade.where(:id => trade_array)

    @rfi_shared = SharedRfi.where(:user_id => session[:user_logged_id])


    @primary_trades = PrimaryTrade.all
    @trade_array = []

    if @primary_trades.present?
      @primary_trades.each do |a|
        @trade_array << a.trade_id
      end
    end


    if @rfi_shared.present?
      rfi_ids = []
      @rfi_shared.each do |r|

        begin
          rfi_shared = Rfi.find(r.rfi_id)

          if rfi_shared.tender_id == @tender.id
            rfi_ids << rfi_shared.id
          end
        rescue
          rfi_ids = []
        end


      end

      @rfi_shares = SharedRfi.where(:rfi_id => rfi_ids.uniq)
      @rfi_shared_array = []
      if @rfi_shares.present?
        @rfi_shares.each do |a|
          @rfi_shared_array << a.rfi_id
        end
      end
    end


    @data = render :partial => 'rfis/latest_rfis'
  end

  def get_rfi_by_trade
    @tender = Tender.find(params[:tender_id])
    if params[:filters].include? 'all'
      @rfis = Rfi.where(:tender_id => @tender.id)
    else

      @rfis = Rfi.where(:tender_id => @tender.id,:trade_id => params[:filters])
    end

    puts "@rfis:#{@rfis.inspect}"
    if @tender.present?
      @user = User.find(@tender.user_id)
    end

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name

      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
      puts "LINK:#{@link}"
    end

    rfi = Rfi.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if rfi.present?
      str = rfi.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "RFI-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "RFI-#{result.upcase}-1"
    end
    puts "USER:#{@sc_user.company}"

    if session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_approved_trades = TenderApprovedTrade.where(:sc_id => session[:user_logged_id],:tender_id => params[:tender_id])
    else
      tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id],:tender_id => params[:tender_id])
    end



    trade_array = []
    if tender_approved_trades.present?
      tender_approved_trades.each do |t|
        trade_array << t.trade_id
      end
    end
    @rfi_document = RfiDocument.new
    @trades = Trade.where(:id => trade_array)

    @data = render :partial => 'rfis/get_latest_rfi_by_trade'
  end

  def create_rfi_document
    puts "params[:document] --------------------->:#{params[:rfi_document][:tender_id]}"
    @tender_id = params[:rfi_document][:tender_id]
    rfi = RfiDocument.new
    rfi.document = params[:document]
    rfi.user_id = session[:user_logged_id]
    rfi.tender_id = params[:rfi_document][:tender_id]
    rfi.rfi_ref_no = params[:rfi_document][:ref_no]
    rfi.save

    render :json => { :state => 'valid'}
  end

  def get_rfi_documents
    @rfi_documents = RfiDocument.where(:user_id => session[:user_logged_id],:rfi_id => nil)
    @data = render :partial => 'rfis/rfi_documents'
  end

  def delete_rfi_documents
    ids = params[:ids]
    if ids.present?
      ids.each do |a|
        if a != 'on'
          RfiDocument.where(:id => a,:tender_id => params[:tender_id]).delete_all
        end
      end
    end

    @rfi_documents = RfiDocument.where("user_id = #{session[:user_logged_id]} and rfi_id = null")
    @data = render :partial => 'rfis/rfi_documents'
  end

  def get_new_ref
    @sc_user = User.find(session[:user_logged_id])
    rfi = Rfi.where(:user_id => session[:user_logged_id]).last()
    result = @sc_user.company.split.map(&:first).join
    if rfi.present?
      str = rfi.ref_no
      last_str = str.split('-')[-1]
      puts "last_str:#{last_str}"
      @ref_no = "RFI-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "RFI-#{result.upcase}-1"
    end

    render :json => { :state => 'valid',:ref => @ref_no}
  end

  def create_rfi
    ref_no = params[:ref_no]
    to = params[:to]
    attention = params[:attention]
    rfi_date = params[:rfi_date]
    response_date = params[:response_date]
    heading = params[:heading]
    trade = params[:trade]
    rfi_desc = params[:rfi_desc]
    tender_id = params[:tender_id]
    date = DateTime.parse("#{params[:response_date]}")

    @tender = Tender.find(tender_id)

    rfi = Rfi.new
    rfi.ref_no = ref_no
    rfi.to = to
    rfi.attention = attention
    rfi.response_date = response_date.to_datetime
    rfi.heading = heading
    rfi.description = rfi_desc
    rfi.trade_id = trade
    rfi.rfi_date = rfi_date
    rfi.tender_id = tender_id
    puts "@tender.user_id:#{@tender.user_id}"
    rfi.hc_id =  @tender.user_id.to_i
    rfi.user_id = session[:user_logged_id]

    if rfi.save
      RfiDocument.where("tender_id = #{tender_id} and rfi_id is null").update_all(:rfi_id => rfi.id)
    end
    @rfis = Rfi.where(:tender_id => tender_id,:user_id => session[:user_logged_id])
    @data = render :partial => 'rfis/rfi_lists'
  end

  def delete_rfis
    ids = params[:ids]
    if ids.present?
      ids.each do |a|
        if a != 'on'
          Rfi.where(:id => a,:tender_id => params[:tender_id]).delete_all
          RfiDocument.where(:rfi_id => a,:tender_id => params[:tender_id]).delete_all
        end
      end
    end

    @rfis = Rfi.where(:tender_id => params[:tender_id],:user_id => session[:user_logged_id])
    @data = render :partial => 'rfis/rfi_lists'
  end

  def download_rfis
    require 'zip'
    tender = Tender.find(params[:tender_id])
    project_name = "#{tender.tendercon_id}-#{tender.title}"
    dir = "#{Rails.root}/public/assets/rfi/#{project_name}"
    Dir.mkdir(dir) unless File.exists?(dir)
    ids = params[:ids]

    @sc_user = User.find(session[:user_logged_id])

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name
      @avatar_path = a.image.path
      puts "@avatar_filename:#{a.image.url}"
      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
    end

    if ids.present?
      ids.each do |a|
        if a != 'on' && a.to_i > 0
          rfi = Rfi.find(a)
          trade = Trade.find(rfi.trade_id)
          hc_user = User.find(rfi.hc_id)
          puts "hc_user:#{hc_user.first_name}"
          dir1 = "#{Rails.root}/public/assets/rfi/#{project_name}/#{rfi.ref_no}"
          Dir.mkdir(dir1) unless File.exists?(dir1)

          Prawn::Document.generate  "#{Rails.root}/public/assets/rfi/#{project_name}/#{rfi.ref_no}.pdf" do |a|
            if @avatar_path.present?
              a.image open(@avatar_path), :width => 100,:height => 100, position:  :right
            end

            a.text "Ref #:                                                                                                   Company: ", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.ref_no}                                                                                                #{hc_user.company}"
            a.move_down 10
            a.text "To                                                                                                         From:", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.to}                                                                     #{hc_user.first_name} #{hc_user.last_name}"
            a.move_down 10
            a.text "Attention", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.attention}"
            a.text "Date", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.rfi_date}"
            a.text "Response Due", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.response_date}"
            a.text "Trade", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{trade.name}"
            a.text "Heading", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.heading}"
            a.text "Description", size: 12, style: :bold, color: "000000"
            a.move_down 10
            a.text "#{rfi.description}"

            if rfi.rfi_documents.present?
              a.move_down 30
              a.text "Document Uploaded"
              if rfi.rfi_documents.present?
                rfi.rfi_documents.each do |d|
                  a.move_down 5
                  a.text "#{d.document_file_name}", :align => :center
                  a.move_down 5
                end
              end
            end

          end
          #if rfi.present?
            if rfi.rfi_documents.present?
              rfi.rfi_documents.each do |a|
                puts "a.document.url:#{a.document.path}"
                if File.exist? a.document.path
                  FileUtils.cp a.document.path, dir1
                end

              end
            end
          #end
        end
      end
    end

    @destination =  "#{Rails.root}/public/assets/rfi/#{project_name}"

    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    new_destination =  "#{Rails.root}/public/assets/rfi/"
    old_folder = "#{Rails.root}/public/assets/rfi/#{project_name}/#{project_name}.zip"
    FileUtils.cp old_folder, new_destination
    FileUtils.rm_rf("#{Rails.root}/public/assets/rfi/#{project_name}/")
    link = "http://#{request.host_with_port}/assets/rfi/#{project_name}.zip"
    render :json => { :state => 'valid',:link => link}
  end

  def zip_documents
    require 'zip'
    tender = Tender.find(params[:tender_id])
    rfi_documents = RfiDocument.where(:rfi_ref_no => params[:ref_no])
    rfi = Rfi.where(:user_id => session[:user_logged_id]).last()
    @sc_user = User.find(session[:user_logged_id])
    result = @sc_user.company.split.map(&:first).join
    if rfi.present?
      str = rfi.ref_no
      last_str = str.split('/')[-1]
      @ref_no = "RFI-#{result.upcase}-#{(last_str.to_i) + 1}"
    else
      @ref_no = "RFI-#{result.upcase}-1"
    end
    project_name = "#{@ref_no}-#{tender.title}"
    if File.directory? "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
      puts "EXIST"
      FileUtils.rm_rf("#{Rails.root}/public/assets/rfi/preview-#{project_name}")
    end

    dir = "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
    Dir.mkdir(dir) unless File.exists?(dir)

    if rfi_documents.present?
      rfi_documents.each do |a|
        if a.document.path.present?
          FileUtils.cp a.document.path, dir
        end

      end
    end


    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name
      @avatar_path = a.image.path
      puts "@avatar_filename:#{a.image.url}"
      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
    end


    Prawn::Document.generate  "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.pdf" do |a|
      if @avatar_path.present?
        a.image open(@avatar_path), :width => 100,:height => 100, position:  :right
      end

      a.text "Ref #:                                                                                                   Company: ", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@ref_no}                                                                                                #{params[:company]}"
      a.move_down 10
      a.text "To                                                                                                         From:", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:to]}                                                                     #{params[:from]}"
      a.move_down 10
      a.text "Attention", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:attention]}"
      a.text "Date", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:rfi_date]}"
      a.text "Response Due", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:response_date]}"
      a.text "Trade", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:trade]}"
      a.text "Heading", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:heading]}"
      a.text "Description", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{params[:rfi_desc]}"

      if rfi_documents.present?
        a.move_down 30
        a.text "Document Uploaded"
        if rfi_documents.present?
          rfi_documents.each do |d|
            a.move_down 5
            a.text "#{d.document_file_name}", :align => :center
            a.move_down 5
          end
        end
      end
    end

    #FileUtils.cp "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.pdf", dir


    @destination =  "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    File.rename("#{Rails.root}/public/assets/rfi/preview-#{project_name}/preview-#{project_name}.zip", "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.zip")
    link = "http://#{request.host_with_port}/assets/rfi/preview-#{project_name}/#{project_name}.zip"
    render :json => { :state => 'valid',:ref_no => "#{@ref_no}-#{tender.title}",:link => link}
  end

  def comments
    require 'zip'
    @rfi = Rfi.find(params[:id])
    if params[:request].present?
      puts "REQUEST"
      @request = true
    end
    @comment_document = CommentDocument.new
    puts "@rfi:#{@rfi.inspect}"
    @tender = Tender.find(params[:tender_id])
    @comments = RfiComment.where(:rfi_id => params[:id])
    @div_array = []

    if session[:role] == 'Head Contractor'
      @sc_user = User.find(@rfi.user_id)
      @rfi.update(:seen => 'true')
    else
      @sc_user = User.find(session[:user_logged_id])
    end

    @sc_user.company_avatars.each do |a|
      @avatar_filename = a.image_file_name
      @avatar_path = a.image.path
      puts "@avatar_filename:#{a.image.url}"
      @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{a.id}/original/#{@avatar_filename}"
    end

    @primary_trades = PrimaryTrade.all
    @trades = []

    if @primary_trades.present?
      @primary_trades.each do |a|
        @trades << a.trade_id
      end
    end


    rfi_documents = RfiDocument.where(:rfi_ref_no => @rfi.ref_no)

    project_name = "#{@rfi.ref_no}-#{@tender.title}"
    if File.directory? "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
      puts "EXIST"
      FileUtils.rm_rf("#{Rails.root}/public/assets/rfi/preview-#{project_name}")
    end

    dir = "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
    Dir.mkdir(dir) unless File.exists?(dir)

    if rfi_documents.present?
      rfi_documents.each do |a|
        if File.exist? a.document.path
          FileUtils.cp a.document.path, dir
        end
      end
    end

    trade = Trade.find(@rfi.trade_id)
    Prawn::Document.generate  "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.pdf" do |a|
      if @avatar_path.present?
        a.image open(@avatar_path), :width => 100,:height => 100, position:  :right
      end

      a.text "Ref #:                                                                                                   Company: ", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.ref_no}                                                                                                #{@sc_user.company}"
      a.move_down 10
      a.text "To                                                                                                         From:", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.to}                                                                     #{@sc_user.first_name} #{@sc_user.last_name}"
      a.move_down 10
      a.text "Attention", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.attention}"
      a.text "Date", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.rfi_date}"
      a.text "Response Due", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.response_date}"
      a.text "Trade", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{trade.name}"
      a.text "Heading", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{p@rfi.heading}"
      a.text "Description", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{@rfi.description}"

      if rfi_documents.present?
        a.move_down 30
        a.text "Document Uploaded"
        if rfi_documents.present?
          rfi_documents.each do |d|
            a.move_down 5
            a.text "#{d.document_file_name}", :align => :center
            a.move_down 5
          end
        end
      end
    end

    #FileUtils.cp "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.pdf", dir


    @destination =  "#{Rails.root}/public/assets/rfi/preview-#{project_name}"
    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end
    File.rename("#{Rails.root}/public/assets/rfi/preview-#{project_name}/preview-#{project_name}.zip", "#{Rails.root}/public/assets/rfi/preview-#{project_name}/#{project_name}.zip")
    @download_link = "http://#{request.host_with_port}/assets/rfi/preview-#{project_name}/#{project_name}.zip"
    @str_token = Digest::MD5.hexdigest(rand(0...1000000).to_s)
  end

  def update_status
    rfi_id = params[:rfi_id]
    rfi = Rfi.find(rfi_id)
    puts  "rfi:#{rfi.status}"
    if rfi.status == nil
      if params[:no].present?
        Rfi.where(:id => rfi_id).update_all(:request => nil)
      else
        Rfi.where(:id => rfi_id).update_all(:status => 'Resolved',:date_resolved => Time.now)
      end
    end
    render :json => { :state => 'valid'}
  end

  def request_to_resolve
    rfi_id = params[:rfi_id]
    rfi = Rfi.find(rfi_id)
    puts  "rfi:#{rfi.status}"
    if rfi.status == nil
      Rfi.where(:id => rfi_id).update_all(:request => session[:user_logged_id])
    end

    render :json => { :state => 'valid'}
  end

end