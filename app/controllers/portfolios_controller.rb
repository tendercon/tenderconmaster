class PortfoliosController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @user = User.find(session[:user_logged_id])
    @portfolios = ProjectPortfolio.where(:company => @user.company)
    @count =  ProjectPortfolio.where(:company => @user.company).count()


    ranges = []
    @categories = []
    @ids = []
    @years = []
    if @portfolios.present?
      @portfolios.each do |p|
        if p.project_range != nil
          ranges << p.project_range
        end
        if p.category_id.to_i > 0
          @categories << p.category_id
        end

        if p.year.to_i > 0
          @years << p.year
        end

        if p.company.present?
          @ids << p.id
        end
      end
    end

    @trades = ProjectTrade.where(:project_portfolio_id => @ids)

    @trade_ids = []
    if @trades.present?
      @trades.each do |t|
        @trade_ids << t.trade_id
      end
    end

    @tops = []
    @top_trades = []

    if @categories.present?
      new_categories = @categories
      @category_size = new_categories.size
      if new_categories.size > 3
        3.times do |a|
          rank = new_categories.uniq.group_by { |e| e }.values.max_by { |values| values.size }.first
          puts "rank:#{rank}"
          @tops << rank
          new_categories.delete(rank)
        end
      end
    end

    if @trade_ids.present?

      if @trade_ids.size > 3
        3.times do |a|
          rank = @trade_ids.uniq.group_by { |e| e }.values.max_by { |values| values.size }.first
          puts "rank:#{rank}"
          @top_trades << rank
          @trade_ids.delete(rank)
        end
      end
    end
    puts "TOPs:#{@tops.inspect}"

    letters = []
    numbers = []
    if ranges.present?
      ranges.each do |r|
        letters << r[-1, 1]
        if (r[-1, 1]) == 'K'
          numbers << r.chomp('K')
        elsif (r[-1, 1]) == 'M'
          numbers << r.chomp('M')
        else
          numbers << r.chomp('M+')
        end
      end
    end
    thousands = []
    millions = []
    million_plus = []
    if letters.present?
      letters.each_with_index do |l,index|
        if l == 'K'
          puts index
          thousands << (numbers[index]).to_i
        elsif l == 'M'
          millions << (numbers[index]).to_i
        else
          million_plus << (numbers[index]).to_i
        end
      end
    end


    if thousands.present?
      @lowest = "#{(thousands.min).to_s}K"
    else
      @lowest = "#{(millions.min).to_s}M"
    end

    if millions.present?
      @highest = "#{(millions.max).to_s}M"
    else
      @highest = "#{(thousands.max).to_s}K"
    end

    if million_plus.present?
      @highest = "#{million_plus.max}M+"
    end

    ProjectPortfolio.where("client is null").delete_all

  end

  def new
    @years = []
    for i in 1800..(Time.now.strftime('%Y').to_i) do
      @years << i
    end

    @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
    @to = ['','5K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

    @trades = Trade.all
    @categories = Category.all
    @portfolio = ProjectPortfolio.new
    @project_avatar = ProjectAvatar.new
    @portfolio.user_id = session[:user_logged_id]
    @portfolio.save
    @new_portfolio = ProjectPortfolio.new
  end

  def create

  end

  def create_project_portfolio
    @user = User.find(session[:user_logged_id])


    @portfolio = ProjectPortfolio.find(params[:project_id])
    @portfolio.client = params[:client]
    @portfolio.year = params[:years]
    @portfolio.user_id = @user.id
    @portfolio.category_id = params[:categories]
    @portfolio.about_me = params[:about_me]
    @portfolio.project_range = params[:range]
    @portfolio.company = @user.company


    proj = ProjectAvatar.where(:project_portfolio_id => @portfolio.id).first


    if proj.present? && params[:client].present?
      if ProjectPortfolio.where(:id => params[:project_id]).update_all(
          :client => params[:client],
          :year => params[:years],
          :user_id => params[:user_id],
          :category_id => params[:categories],
          :about_me => params[:about_me],
          :project_range => params[:range],
          :company => @user.company
      )
        ProjectPortfolio.where("id = #{@portfolio.id} and category_id is null").destroy_all
        ProjectTrade.where(:project_portfolio_id => @portfolio.id).destroy_all

        # s_array = []
        #
        # if params[:secondary_trade1].present? && params[:secondary_trade1].to_i > 0
        #   s_array << params[:secondary_trade1]
        # end
        #
        # if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
        #   s_array << params[:secondary_trade2]
        # end
        #
        # if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
        #   s_array << params[:secondary_trade3]
        # end
        #
        # if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
        #   s_array << params[:secondary_trade4]
        # end
        #
        # if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
        #   s_array << params[:secondary_trade5]
        # end
        #
        # if params[:secondary_trade6].present? && params[:secondary_trade6].to_i > 0
        #   s_array << params[:secondary_trade6]
        # end
        #
        # if params[:secondary_trade7].present? && params[:secondary_trade7].to_i > 0
        #   s_array << params[:secondary_trade7]
        # end
        #
        # if params[:secondary_trade8].present? && params[:secondary_trade8].to_i > 0
        #   s_array << params[:secondary_trade8]
        # end
        #
        # if params[:secondary_trade9].present? && params[:secondary_trade9].to_i > 0
        #   s_array << params[:secondary_trade9]
        # end
        #
        # if params[:secondary_trade10].present? && params[:secondary_trade10].to_i > 0
        #   s_array << params[:secondary_trade10]
        # end
        #
        #
        #
        # if s_array.present?
        #   s_array.each do |s|
        #     project_trades = ProjectTrade.new
        #     project_trades.trade_id = s
        #     project_trades.user_id = @portfolio.user_id
        #     project_trades.project_portfolio_id = @portfolio.id
        #     project_trades.save
        #   end
        # end

        s_array = []

        if params[:trades].present? && params[:trades].to_i > 0
          s_array << params[:trades]
        else
          if params[:project_trade1].present?
            trade = Trade.new
            trade.name = params[:project_trade1]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade1]
          end

        end

        if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
          s_array << params[:secondary_trade2]
        else
          if params[:project_trade2].present?
            trade = Trade.new
            trade.name = params[:project_trade2]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade2]
          end
        end

        if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
          s_array << params[:secondary_trade3]
        else
          if params[:project_trade3].present?
            trade = Trade.new
            trade.name = params[:project_trade3]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade3]
          end
        end

        if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
          s_array << params[:secondary_trade4]
        else
          puts "ELSE:#{params[:project_trade4]}"
          if params[:project_trade4].present?
            trade = Trade.new
            trade.name = params[:project_trade4]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade4]
          end
        end

        if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
          s_array << params[:secondary_trade5]
        else
          if params[:project_trade5].present?
            trade = Trade.new
            trade.name = params[:project_trade5]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade5]
          end
        end

        if s_array.present?
          s_array.each do |s|
            if s.to_i > 0
              project_trades = ProjectTrade.new
              project_trades.trade_id = s
              project_trades.user_id = @portfolio.user_id
              project_trades.project_portfolio_id = @portfolio.id
              project_trades.save
            end

          end
        end

        project_address = ProjectAddress.new
        project_address.state = params[:state]
        project_address.location = params[:address]
        project_address.suburb = params[:suburb]
        project_address.postcode = params[:postcode]
        project_address.project_portfolio_id = @portfolio.id
        project_address.user_id = @portfolio.user_id
        project_address.save
        ProjectPortfolio.where("client is null").delete_all
        flash[:notice] = "New project successfully added."
        redirect_to portfolios_path
      end
    else

      if !params[:client].present? && !proj.present?
        flash[:error] = "Project client and photos is required."
      elsif !params[:client].present?
        flash[:error] = "Project client is required."
      elsif !proj.present?
        flash[:error] = "Project photo is required."
      end

      ProjectPortfolio.where("client is null").delete_all
      redirect_to :back
    end





  end

  def create_project_avatar
    avatar = ProjectAvatar.new(project_avatar_premitted_params)

    #ProjectAvatar.where(:user => params[:project_avatar][:user_id]).destroy_all

    if avatar.save
      url = request.host_with_port+"/assets/project_avatar/image/#{avatar.id}/original/#{avatar.image_file_name}"
      puts "AVATAR:#{url}"

      urls = []

      project_avatars = ProjectAvatar.where(:user_id => params[:project_avatar][:user_id])

      if project_avatars.present?
        project_avatars.each do |u|
          urls << request.host_with_port+"/assets/project_avatar/image/#{u.id}/original/#{u.image_file_name}"
        end
      end
      puts "urls:#{urls.inspect}"


      render :json => { :state => 'valid',:avatar_url => url}
    else
      render :json => { :state => 'invalid',:errors => 'Image should be jpg and png. And maximum of 1mb.'}
    end
  end

  def get_project_photos
    @urls = []
    @ids = []
    id = params[:id]
    project_avatars = ProjectAvatar.where(:user_id => id,:project_portfolio_id => params[:project_id])

    if project_avatars.present?
      project_avatars.each do |u|
        @ids << u.id
        @urls << request.host_with_port+"/assets/project_avatar/image/#{u.id}/original/#{u.image_file_name}"
      end
    end
    puts "URLS:#{@urls.inspect}"
    @data = render :partial => 'portfolios/project_photos'
  end

  def edit
    @portfolio = ProjectPortfolio.find(params[:id])
    puts "@portfolio:#{@portfolio.inspect}"
    @trade_array = []
    @urls = []
    @ids = []
    if @portfolio.project_trades.present?
      @portfolio.project_trades.each do |p|
        @trade_array <<  p.trade_id
      end
    end

    project_avatars = ProjectAvatar.where(:project_portfolio_id => @portfolio.id )

    if project_avatars.present?
      project_avatars.each do |u|
        @ids << u.id
        @urls << request.host_with_port+"/assets/project_avatar/image/#{u.id}/original/#{u.image_file_name}"
      end
    end
    puts "IDS:#{@ids}"
    @years = []
    for i in 1800..(Time.now.strftime('%Y').to_i) do
      @years << i
    end

    @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
    @to = ['','5K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

    @trades = Trade.all
    @categories = Category.all
    @secondary_trade = ProjectTrade.where(:project_portfolio_id => params[:id])

    @secondary_trade_array = []

    if @secondary_trade.present?
      @secondary_trade.each do |a|
        @secondary_trade_array << a.trade_id
      end
    end

    @project_avatar = ProjectAvatar.new
    @portfolio.user_id = session[:user_logged_id]
    @new_portfolio = ProjectPortfolio.new
  end

  def update
    @portfolio = ProjectPortfolio.find(params[:portfolio_id])
    @user = User.find(session[:user_logged_id])
    @user.company
    puts "params[:about_me]:#{params[:about_me]}"
    if ProjectPortfolio.where(:id => params[:portfolio_id]).update_all(
          :client => params[:client],
          :year => params[:years],
          :user_id => @user.id,
          :category_id => params[:categories],
          :about_me => params[:about_me],
          :project_range => params[:range],
          :company => @user.company
    )

        ProjectTrade.where(:project_portfolio_id => @portfolio.id).destroy_all

        s_array = []

        if params[:trades].present? && params[:trades].to_i > 0
          s_array << params[:trades]
        else
          if params[:project_trade1].present?
            trade = Trade.new
            trade.name = params[:project_trade1]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade1]
          end

        end

        if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
          s_array << params[:secondary_trade2]
        else
          if params[:project_trade2].present?
            trade = Trade.new
            trade.name = params[:project_trade2]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade2]
          end
        end

        if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
          s_array << params[:secondary_trade3]
        else
          if params[:project_trade3].present?
            trade = Trade.new
            trade.name = params[:project_trade3]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade3]
          end
        end

        if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
          s_array << params[:secondary_trade4]
        else
          puts "ELSE:#{params[:project_trade4]}"
          if params[:project_trade4].present?
            trade = Trade.new
            trade.name = params[:project_trade4]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade4]
          end
        end

        if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
          s_array << params[:secondary_trade5]
        else
          if params[:project_trade5].present?
            trade = Trade.new
            trade.name = params[:project_trade5]
            trade.status = 1
            trade.save
            s_array << trade.id
          else
            s_array << params[:project_trade5]
          end
        end

        if s_array.present?
          s_array.each do |s|
            if s.to_i > 0
              project_trades = ProjectTrade.new
              project_trades.trade_id = s
              project_trades.user_id = @portfolio.user_id
              project_trades.project_portfolio_id = @portfolio.id
              project_trades.save
            end

          end
        end

        ProjectAddress.where(:project_portfolio_id => @portfolio.id).update_all(
          :state => params[:state],
          :location => params[:address],
          :suburb => params[:suburb],
          :postcode => params[:postcode]
        )
        flash[:notice] = "Project successfully updated."
       redirect_to portfolios_path

    end

  end

  def update_portfolio

  end

  def show
    @portfolio = ProjectPortfolio.find(params[:id])
    @trade_array = []
    @urls = []
    if @portfolio.project_trades.present?
      @portfolio.project_trades.each do |p|
        @trade_array <<  p.trade_id
      end
    end

    project_avatars = ProjectAvatar.where(:project_portfolio_id => @portfolio.id )

    if project_avatars.present?
      project_avatars.each do |u|
        @ids = u.id
        @urls << request.host_with_port+"/assets/project_avatar/image/#{u.id}/original/#{u.image_file_name}"
      end
    end

  end

  def delete

  end

  def delete_project_avatar
    avatar =  ProjectAvatar.find(params[:id])

    if avatar.destroy
      @urls = []
      @ids = []
      project_avatars = ProjectAvatar.where(:project_portfolio_id => params[:portfolio])

      if project_avatars.present?
        project_avatars.each do |u|
          @ids = u.id
          @urls << request.host_with_port+"/assets/project_avatar/image/#{u.id}/original/#{u.image_file_name}"
        end
      end
      puts "URLS:#{@urls.inspect}"
      @data = render :partial => 'portfolios/project_photos'
    end

  end

  def delete_portfolio
    portfolio = ProjectPortfolio.find(params[:id])

    if portfolio.destroy
      ProjectAddress.where(:project_portfolio_id => params[:id]).destroy_all
      ProjectAvatar.where(:project_portfolio_id => params[:id]).destroy_all
      ProjectTrade.where(:project_portfolio_id => params[:id]).destroy_all
      flash[:notice] = "Project successfully deleted."
      redirect_to portfolios_path

    end
  end

  def download_portfolio

    respond_to do |format|
      format.html
      format.pdf do

        @id = params[:id]
        @pdf = Prawn::Document.new(options={:page_layout => :portrait})
        @pdf = PortfolioPdf.new(@id)
        send_data @pdf.render, :filename => "#{@user.first_name}#{@user.last_name}ProfileTendercon.pdf", :type => "application/pdf"
      end
    end
  end

  private

  def project_portfolios_premitted_params
    params.require(:project_avatar).permit(:id,:user_id,:parent_id,:client,:year,:about_me,:category_id)
  end

  def project_avatar_premitted_params
    params.require(:project_avatar).permit(:id,:user_id,:image,:project_portfolio_id)
  end

end