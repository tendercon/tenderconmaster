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
      puts "@ref_num======> #{@ref_num}"
    else
      last_addenda = Addenda.where(:tender_id => @tender.id,:user_id => session[:user_logged_id]).last
      if last_addenda.present?
        @ref_num =  "Addendum ##{rand(last_addenda.id..1000)}"
      else
        @ref_num =  "Addendum ##{rand(1..1000)}"
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
      @addenda = Addenda.new
      @addenda.subject = subject
      @addenda.details = details
      @addenda.tender_id = params[:tender_id]
      @addenda.user_id = session[:user_logged_id]
      @addenda.addenda_type = params[:addenda_type]
      @addenda.ref_no = params[:addenda][:ref_no]
      @addenda.status = 'incomplete'

      if @addenda.save
        if params[:addenda_type] == 'details'
          redirect_to new_addenda_path(:id => params[:tender_id],:addenda => @addenda.id,:type => 'details',:updates => true)
        else
          redirect_to new_addenda_path(:id => params[:tender_id],:addenda => @addenda.id,:addenda_type => 'documents',:documents => true)
        end
      else
        flash[:error] = 'Subject required.'
        redirect_to :back
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
          TenderconMailer.delay.tender_changed(params[:subject],params[:details],user.email,user.first_name,@tender.title,@addenda.addenda_type)
        end
      end
    end
    Addenda.where(:tender_id => @tender.id).update_all(:status => 'completed')
    TenderDocument.where(:user_id => session[:user_logged_id],:tender_id => @tender,:action_type => 'addenda',:addenda_id => nil).update_all(:addenda_id => @addenda)


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

  def get_addendas
    @tender = Tender.find(params[:tender_id])
    if session[:role] == 'Head Contractor'
      @addendas = Addenda.where(:tender_id => @tender.id,:user_id => session[:user_logged_id],:status => 'completed')
    else
      @addendas = Addenda.where(:tender_id => @tender.id)
    end

    @addenda_document = Addenda.new
    @ip = request.host_with_port
    @data = render :partial => 'addendas/lists'
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

  def update_quote_due
    id = params[:quote_id]
      if params[:type] == 'quote'
        quote = TenderQuote.find(id)
        TenderQuote.where(:id => id).update_all(:quote_date => params[:quote_date],:previous_date => quote.quote_date)
        updated_quote =  TenderQuote.find(id)
        render :json => { :state => 'valid',:quote => (updated_quote.quote_date.to_datetime).strftime("%m/%d/%Y %H:%M %p")}
      end

      if params[:type] == 'status'
        Tender.where(:id => params[:tender_id]).update_all(:status => params[:status],:status_updated => 'true')
        render :json => { :state => 'valid',:tender_status => params[:status]}
      end
  end
end