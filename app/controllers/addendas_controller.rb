class AddendasController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    puts "INDEX"
    @tender = Tender.find(params[:id])
    TenderDocument.where("user_id = #{session[:user_logged_id]} and addenda_id is null and action_type = 'addenda'").delete_all()
  end

  def new
    @directories = []
    @tender = Tender.find(params[:id])
    @addenda = Addenda.new
    @documents = TenderDocument.where(:tender_id => @tender.id,:action_type => 'addenda').where("addenda_id is null").order('created_at desc,directory desc')
    @edited_addenda = Addenda.where(:id => params[:addenda]).last
    if @edited_addenda.present?
      @ref_num  =  @edited_addenda.ref_no
    else
      last_addenda = Addenda.where(:tender_id => @tender.id,:user_id => session[:user_logged_id],:status => 'completed').last
      if last_addenda.present?
        a = last_addenda.ref_no.gsub(/[^0-9]/, '')
        puts "last_addenda.ref_no.last(4)).to_i + 1 =======> #{a}"
        @ref_num =  "Addendum ##{a.to_i + 1}"
      else
        @ref_num =  "Addendum #1"
      end
    end

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          if u.directory.present?
            @directories << u.directory
          end
        end
      end
    end
    @new_direcotires = @directories.reject { |c| c.present? ?  c.empty? : nil }
    @addenda_document = TenderDocument.new

    @document_packages = DocumentPackage.where(:tender_id => @tender.id)

    @package_array
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
    @tender_packages = TenderPackage.where(:tender_id => @tender.id).order("category_id asc")
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

    @tender_package_count = TenderPackage.where(:tender_id => @tender.id).count()

    @tender_package_array = []
    @tender_package_array_1 = []
    @tender_package_array_2 = []
    @trade_ids = []
    if @tender_packages.present?
      @tender_packages.each do |p|
        @trade_ids << p.trade_id
      end
    end

    @packages = Package.where(:tender_id => @tender.id)
    @package_lists = []
    if @packages.present?
      @packages.each do |p|
        @package_lists << p.code
      end
    end

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

    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id,:action_type => 'addenda').where("addenda_id is null").order('created_at desc,directory desc')
    @directories = []

    if @documents.present?
      @documents.each do |u|
        if u.directory != 'unzip'
          @directories << u.directory
        end
      end
    end


    @tender = Tender.find(tender_id)

    @data = render :partial => 'addendas/documents/get_documents'
  end

  def create
    subject = params[:addenda][:subject]
    details = params[:addenda][:details]
    #qoute_date = params[:qoute]
    #qoute_time = params[:qoute_time]


    addenda_id = params[:addenda_id]
    if addenda_id.present?
      Addenda.where(:id => addenda_id).update_all(:subject => subject,:details => details)
      if params[:addenda_type] == 'details'
        redirect_to new_addenda_path(:id => params[:tender_id],:addenda => addenda_id,:type => 'details',:updates => true)
      else
        redirect_to new_addenda_path(:id => params[:tender_id],:addenda => addenda_id,:addenda_type => 'documents',:documents => true)
      end
    else

      puts "TEST ==============> #"
      @addenda = Addenda.new
      @addenda.subject = subject
      @addenda.details = details
      @addenda.tender_id = params[:tender_id]
      @addenda.user_id = session[:user_logged_id]
      @addenda.addenda_type = params[:addenda_type]
      @addenda.ref_no = params[:addenda][:ref_no]
      @addenda.status = 'incomplete'
      addendas = Addenda.where(:ref_no => params[:addenda][:ref_no], :tender_id => params[:tender_id],:user_id => session[:user_logged_id],:status => 'completed')

      unless addendas.present?
        if @addenda.save
          if params[:addenda_type] == 'details'
            puts "TEST ==============> 1#"
            redirect_to new_addenda_path(:id => params[:tender_id],:addenda => @addenda.id,:type => 'details',:updates => true)
          else
            puts "TEST ==============> 2#"
            redirect_to new_addenda_path(:id => params[:tender_id],:addenda => @addenda.id,:addenda_type => 'documents',:documents => true)
          end
        else
          puts "TEST ==============> 3#"
          flash[:error] = 'Subject required.'
          redirect_to :back
        end
      end


    end
  end

  def update_details

  end

  def matrix
    puts "params[:addenda] =======> #{params[:addenda]}"
    @tender = Tender.find(params[:tender_id])
    @documents = TenderDocument.where(:tender_id => @tender.id,:action_type => 'addenda').where("addenda_id is null")
    @addenda = Addenda.find(params[:addenda])

    @document_packages = DocumentPackage.where(:tender_id => @tender.id)

    @package_array
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
    @tender_packages = TenderPackage.where(:tender_id => @tender.id).order("category_id asc")
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

    @tender_package_count = TenderPackage.where(:tender_id => @tender.id).count()

    @tender_package_array = []
    @tender_package_array_1 = []
    @tender_package_array_2 = []
    @trade_ids = []
    if @tender_packages.present?
      @tender_packages.each do |p|
        @trade_ids << p.trade_id
      end
    end

    @packages = Package.where(:tender_id => @tender.id)
    @package_lists = []
    if @packages.present?
      @packages.each do |p|
        @package_lists << p.code
      end
    end

  end

  def review
    @addenda = Addenda.find(params[:addenda])
    @tender = Tender.find(params[:id])
    @documents = TenderDocument.where(:tender_id => @tender.id,:action_type => 'addenda').where("addenda_id is null")
  end

  def notify_subcontractors
    @addenda = Addenda.new
    @tender = Tender.where(:id => params[:id]).first
    @edited_addenda = Addenda.where(:id => params[:addenda]).first
  end

  def issue_addenda
    @tender = Tender.find(params[:id])
    @addenda = Addenda.find(params[:addenda])
    if params[:trades].present?
      params[:trades].each do |t|
        tender_approved = TenderApprovedTrade.where(:tender_id => t, :tender_id => @tender.id).first
        if tender_approved.present?
          notification = Notification.new
          notification.user_id = tender_approved.sc_id
          if @addenda.addenda_type == 'details'
            notification.description = "#{@tender.title} details was changed."
          else
            notification.description = "#{@tender.title} document was changed."
          end
          notification.save
          user = User.find(tender_approved.sc_id)



          #TenderconMailer.tender_changed(params[:subject],params[:details],user.email,user.first_name,@tender.title,@addenda.addenda_type).deliver_now
        end
      end
    end

    Addenda.where(:tender_id => @tender.id,:id => @addenda.id).update_all(:status => 'completed')
    TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender,:action_type => 'addenda',:addenda_id => nil).update_all(:addenda_id => @addenda)
    @tendering = TenderRequestQuote.where(:tender_id => @tender).where("request_date is not null")
    if(@tendering).present?
      @tendering.each do |tendering|
        addenda = AddendaNotification.where(:addenda_id => @addenda.id, :tender_id => @tender.id,:sc_id => tendering.sc_id)
        if tendering.trade_id.to_i > 0
          trade = Trade.find(tendering.trade_id.to_i)
        end

        message = "#{@tender.user.trade_name} has issued a new Addendum on project #{@tender.title}"
        TenderconMailer.tender_changed(tendering.sc_id,@tender.id,@addenda.created_at.strftime("%d.%m.%Y %H:%M %p"),"http://"+request.host_with_port+"/users/login").deliver_now
        unless addenda.present?
          AddendaNotification.notification(tendering.sc_id,@tender.id,@tender.user_id,@addenda.id,message,"HC")
        end
      end
    end


    Addenda.where(:tender_id => @tender.id,:status => 'incomplete').delete_all
    flash[:notice] = 'New Addenda added.'
   redirect_to  "/tenders/hc_tender?id=#{@tender.id}&addenda=true"
  end

  def create_addendas
    addenda = Addenda.new
    addenda.tender_id = params[:tender_id]
    addenda.user_id = session[:user_logged_id]
    addenda.subject = params[:subject]
    addenda.details = params[:details]
    addenda.addenda_type = params[:type]


    if addenda.save
      Addenda.where(:id => addenda.id).update_all(:ref_no => addenda.id)
      render :json => { :state => 'valid'}
    end

  end


  def create_packages
    packages = params[:package]
    tender_id = params[:tender_id]
    addenda = params[:addenda]
    docs = Hash.new
    document_array = []
    @addenda = Addenda.find(addenda)
    @array = []
    @tender = Tender.find(tender_id)
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


                end
              end
            end
          end
          DocumentPackage.where(:tender_id =>  tender_id).destroy_all
          Tender.delay.compressed_document_matrix(dir,tender_id,session[:user_logged_id],request.host_with_port)
        end
      end
    end
    puts "dsakjdksakdjsakdjksadjsa=====================>"
    redirect_to new_addenda_path(:id => @tender.id,:addenda => @addenda.id,:addenda_type => params[:addenda_type],:notify => true)


  end

  def get_addendas
    @tender = Tender.find(params[:tender_id])
    if session[:role] == 'Head Contractor'
      addendas = Addenda.where(:tender_id => @tender.id,:user_id => session[:user_logged_id],:status => 'completed')
      addenda_array = []
      addenda_ids = []
      if addendas.present?
        addendas.each do |a|
          if !addenda_array.include?(a.ref_no)
            addenda_array << a.ref_no
            addenda_ids << a.id
          end

        end
      end

      @addendas = Addenda.where(:id => addenda_ids)

    else
      addendas = Addenda.where(:tender_id => @tender.id, :status => 'completed')
      addenda_array = []
      addenda_ids = []
      if addendas.present?
        addendas.each do |a|
          if !addenda_array.include?(a.ref_no)
            addenda_array << a.ref_no
            addenda_ids << a.id
          end

        end
      end
      @addendas = Addenda.where(:id => addenda_ids)
    end

    @addenda_document = Addenda.new
    @ip = request.host_with_port
    @data = render :partial => 'addendas/lists'

    AddendaNotification.where(:sc_id => session[:user_logged_id]).delete_all

  end

  def create_addenda_document
    @tender = Tender.find(params[:tender_id])

    document = TenderDocument.new
    document.tender_id = @tender.id
    document.document = params[:document]
    document.user_id = session[:user_logged_id]

    document.action_type = 'addenda'
    search = 'Header'
    doc = TenderDocument.where("directory LIKE '%#{search}%' AND tender_id = #{@tender.id}").last

    if doc.present?
      last = doc.directory[/\d+/]
      new = (last).to_i + 1
      document.directory = "Header#{new}"
    else
      document.directory = "Header1"
      #end
    end
    if  params[:directory].present?

      document.directory = params[:directory]
    end
    document.save
    TenderDocument.where("document_file_name ='.DS_Store'").delete_all()
    if params[:directory].present?
      doc = TenderDocument.where(:tender_id => @tender.id,:directory => params[:directory],:user_id => session[:user_logged_id]).first
      puts "doc ==========> #{doc.inspect}"
      if doc.present?
        puts "PRESENT ==========>"
        TenderDocument.where(:tender_id => @tender.id,:directory => params[:directory],:user_id => session[:user_logged_id]).where("addenda_id is null").update_all(:created_at => doc.created_at,:updated_at => doc.updated_at)
      end
      render :json => { :state => 'valid',:directory => params[:directory]}
    else
      render :json => { :state => 'valid'}
    end

  end

  def get_documents
    @unzip_dirs = []
    @docs1 = []
    directory = params[:directory]
    files = params[:out]
    directories = params[:directories].present? ? params[:directories].reject { |c| c.empty? } : nil
    tender_id = params[:tender_id]
    puts "directories ========> #{directories.present?}"
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
      if params[:out].size == files.size
        directories.each_with_index do |d,i|
          file_dir = TenderDocument.where(:directory => "#{d}").first
          if file_dir.present?
            TenderDocument.where(:id => ids[i],:tender_id => tender_id,:user_id => session[:user_logged_id],:action_type => 'addenda').where("addenda_id is null").update_all(:directory => d,:created_at => file_dir.created_at,:updated_at => file_dir.created_at,:status => 'modified')
          else
            TenderDocument.where(:id => ids[i],:tender_id => tender_id,:user_id => session[:user_logged_id],:action_type => 'addenda').where("addenda_id is null").update_all(:directory => d,:status => 'modified')
          end
        end
      end
    else
      TenderDocument.where(:tender_id => tender_id,:user_id => session[:user_logged_id]).update_all(:status => 'modified')
    end

    #if directory.present?
    #  if params[:out].present?
    #    params[:out].each do |d|
    #      doc = TenderDocument.where(:document_file_name => "#{d}",:tender_id => tender_id,:user_id => session[:user_logged_id]).first
    #      puts  "doc ========> #{doc.inspect}"
    #      if doc.present?
    #        TenderDocument.where(:id => doc.id,:tender_id => tender_id,:user_id => session[:user_logged_id],:action_type => 'addenda').where("addenda_id is null").update_all(:directory => directory,:created_at => doc.created_at,:updated_at => doc.created_at,:status => 'modified')
    #      end
    #    end
    #  end

    #xend

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


    @tender = Tender.find(tender_id)
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => tender_id,:action_type => 'addenda').where("addenda_id is null").order('created_at desc,directory desc')
    @data = render :partial => 'addendas/documents/get_documents'
  end


  def delete_documents
    id_array = params[:ids]
    ids = []

    if id_array.present?
      id_array.each do |i|
        if i != 'on'
          ids << i
        end
      end
    end
    if ids.present?
      ids.each do |id|
        TenderDocument.where(:id => id).destroy_all

      end
    end
    @tender = Tender.find(params[:tender_id])
    @documents = TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender.id,:action_type => 'addenda').where("addenda_id is null").order('created_at desc,directory desc')
    @data = render :partial => 'addendas/documents/get_documents'

  end


  def download
    require 'zip'
    tender = Tender.find(params[:tender_id])
    addenda_id = params[:addenda_id]

    @sc_user = User.find(session[:user_logged_id])
    #dir = "#{Rails.root}/public/assets/tender/document/Fullset-#{tender.tendercon_id}"
    #FileUtils.makedirs(dir)

    dir = "#{Rails.root}/public/assets/quotes/Fullset-#{tender.tendercon_id}"
    FileUtils.makedirs(dir)

    if addenda_id.present?
      addenda = Addenda.find(addenda_id)
      hc_user = User.find(tender.user_id)
      puts "hc_user:#{hc_user.first_name}"

      #dir1 = "#{Rails.root}/public/assets/tender/document/Fullset-#{tender.tendercon_id}"
      #FileUtils.makedirs(dir1)

      dir1 = "#{Rails.root}/public/assets/quotes/Fullset-#{tender.tendercon_id}"
      FileUtils.makedirs(dir1)
      tender_docoments = TenderDocument.where(:addenda_id => addenda_id)
      if tender_docoments.present?
        tender_docoments.each do |a|
          puts "a.document.url:#{a.document.path}"
          if File.exist? a.document.path
            FileUtils.cp a.document.path, dir1
          end
        end
      end
    end



    @destination =  "#{Rails.root}/public/assets/quotes/Fullset-#{tender.tendercon_id}"

    @destination.sub!(%r[/$],'')

    archive = File.join(@destination,File.basename(@destination))+'.zip'
    FileUtils.rm archive, :force=>true

    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
        zipfile.add(file.sub(@destination+'/',''),file)
      end
    end

    new_destination =  "#{Rails.root}/public/assets/quotes/"
    old_folder = "#{Rails.root}/public/assets/quotes/Fullset-#{tender.tendercon_id}/Fullset-#{tender.tendercon_id}.zip"
    FileUtils.cp old_folder, new_destination
    if !addenda_id.present?
      FileUtils.rm_rf("#{Rails.root}/public/assets/quotes/Fullset-#{tender.tendercon_id}/")
    end



    if addenda_id.present?
      link = "http://#{request.host_with_port}/assets/quotes/Fullset-#{tender.tendercon_id}.zip"
      puts "---------->link:#{link}"
      render :json => { :state => 'valid',:link => link}
    end
  end

  def update_quote_due
    id = params[:quote_id]

    addenda_change = AddendaChange.new
    if params[:type] == 'quote'
      quote = TenderQuote.find(id)
      TenderQuote.where(:id => id).update_all(:quote_date => params[:quote_date],:previous_date => quote.quote_date, :updated_at => Time.now)
      if quote.previous_date.to_datetime != params[:quote_date]

        addenda_change_saved = AddendaChange.where(:addenda_id => params[:addenda_id]).first

        if addenda_change_saved.present?
          AddendaChange.where(:id => addenda_change_saved.id).update_all(:previous_date => quote.quote_date)
        else
          addenda_change.addenda_id = params[:addenda_id]
          addenda_change.previous_date =  quote.quote_date
          addenda_change.save
        end
      end
      updated_quote =  TenderQuote.find(id)
      render :json => { :state => 'valid',:quote => (updated_quote.quote_date.to_datetime).strftime("%m/%d/%Y %H:%M %p")}
    end

    if params[:type] == 'status'
      tender = Tender.find(params[:tender_id])
      Tender.where(:id => params[:tender_id]).update_all(:status => params[:status],:status_updated => 'true',:updated_at => Time.now)
      if tender.status.to_i != params[:status].to_i

        addenda_change_saved = AddendaChange.where(:addenda_id => params[:addenda_id]).first

        if addenda_change_saved.present?
          AddendaChange.where(:id => addenda_change_saved.id).update_all(:previous_status => tender.status)
        else
          addenda_change.addenda_id = params[:addenda_id]
          addenda_change.previous_status =  tender.status
          addenda_change.save
        end

      end
      render :json => { :state => 'valid',:tender_status => params[:status]}
    end


  end
end