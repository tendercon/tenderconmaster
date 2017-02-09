class UsersController < ApplicationController
  #layout 'users_layout', :on => [:login],:except => [:profile,:company_profile,:index,:edit_profile,:billing,:change_password,:edit_company_profile,:subscription,:register,:welcome_page,
  #                                                  :tendercon_steps,:steps_completed,:registration_completed]
  #layout 'users_layout', :only => [:login]
  layout 'in_apps_layout', :only => [:register,:tendercon_steps,:login,:token_expired,:registration_completed,
                                     :welcome_page,:steps_completed,:user_company_exist,:account_taken,:forgot_password,
                                     :validation_complete,:reset_password,:password_changed,:create_user,:token_expired,:update_password]
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
  end

  def lists
    @type = params[:type]


    if @type == 'All'
      @users = User.all
      @data = render :partial => 'users/all'
    elsif @type == 'Deleted'
      @users = User.where(:status => 'deleted')
      @data = render :partial => 'users/deleted'
    elsif @type == 'Suspended'
      @users = User.where(:status => 'suspended')
      @data = render :partial => 'users/suspended'
    elsif @type == 'Completed'
      @users = User.where("abn is not NULL and status is null")
      @data = render :partial => 'users/completed'
    elsif @type == 'Incomplete'
      @users = User.where("abn is null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    end
  end

  def delete_user
    id = params[:id]
    @type = params[:type]
    User.where(:id => id).update_all(:status => 'deleted')

    if @type == 'All'
      @users = User.all
      @data = render :partial => 'users/all'
    elsif @type == 'Deleted'
      @users = User.where(:status => 'deleted')
      @data = render :partial => 'users/deleted'
    elsif @type == 'Suspended'
      @users = User.where(:status => 'suspended')
      @data = render :partial => 'users/suspended'
    elsif @type == 'Completed'
      @users = User.where("abn is null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    elsif @type == 'Incomplete'
      @users =  User.where("abn is null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    end
  end

  def suspend_user
    id = params[:id]
    @type = params[:type]
    User.where(:id => id).update_all(:status => 'suspended')

    if @type == 'All'
      @users = User.all
      @data = render :partial => 'users/all'
    elsif @type == 'Deleted'
      @users = User.where(:status => 'deleted')
      @data = render :partial => 'users/deleted'
    elsif @type == 'Suspended'
      @users = User.where(:status => 'suspended')
      @data = render :partial => 'users/suspended'
    elsif @type == 'Completed'
      @users = User.where("abn is not null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    elsif @type == 'Incomplete'
      @users =  User.where("abn is null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    end
  end

  def activate_user
    id = params[:id]
    @type = params[:type]
    User.where(:id => id).update_all(:status => nil)

    if @type == 'All'
      @users = User.all
      @data = render :partial => 'users/all'
    elsif @type == 'Deleted'
      @users = User.where(:status => 'deleted')
      @data = render :partial => 'users/deleted'
    elsif @type == 'Suspended'
      @users = User.where(:status => 'suspended')
      @data = render :partial => 'users/suspended'
    elsif @type == 'Completed'
      @users = User.where("abn is not null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    elsif @type == 'Incomplete'
      @users =  User.where("abn is null OR (status != 'deleted' AND status != 'suspended')")
      @data = render :partial => 'users/completed'
    end
  end

  def login
    if params[:tender].present?
      TenderInvite.where(:tender_id => params[:tender],:trade_id => params[:trade],:email => params[:email]).update_all(:status => 'accepted')
    end
  end

  def logout
    if @diff.present?
      if @diff <= 0
        UserSubscription.where(:user_id => session[:user_logged_id]).update_all(:lightbox4 => 0)
      end
    end

    User.where(:id => session[:user_logged_id]).update_all(:logged_status => 'offline')
    @url = nil
    session[:name] = nil
    session[:user_logged_id] = nil
    session[:email] = nil
    session[:time_logged] = nil
    session[:azure_token] = nil
    session[:user_email] = nil

    if params[:status].present?
      redirect_to login_users_path
    else
      redirect_to login_users_path(:url => request.referer)
    end

  end

  def locked
    #session[:time_logged] = nil
    @url = request.referer
    if session[:original_url].present?
      if session[:original_url] != @url
        @url = session[:original_url]
      end
    else
      session[:original_url] = request.referer
    end

    session[:user_logged_id] = nil
    @email = session[:email]
  end

  def register
    @user = User.new
    @user.companies.build
    @roles = [ 'Head Contractor','Sub Contractor' ]
    if params[:tender].present?
      TenderInvite.where(:tender_id => params[:tender],:trade_id => params[:trade],:email => params[:email]).update_all(:status => 'accepted')
    end
  end

  def create

  end

  def create_user
    @status = params[:status]

    if @status.present?
      @user = User.new
      @name = params[:first_name]
      @email = params[:email]
      @company = params[:company]
      @password = params[:password]
      @confirmed_password = params[:confirmed_password]
      old_company = nil
    else
      @user = User.new(user_premitted_params)
      if params[:role] == 'SC'
        @user.role = 'Sub Contractor'
      elsif  params[:role] == 'HC'
        @user.role = 'Head Contractor'
      end
      @name = params[:user][:first_name]
      @email = params[:user][:email]
      @company = params[:user][:company][:name]
      @password = params[:user][:password]
      @confirmed_password = params[:user][:confirmed_password]


      old_company = Company.where(:name => @company)
    end

    all_users = User.all

    if !all_users.present?
      @user.role = 'Admin'
    end

    @user.unique_key = Digest::MD5.hexdigest(@email)
    @roles = [ 'Head Contractor','Sub Contractor' ]


    if old_company.present?
      session[:name] = @name
      session[:password] = @password
      session[:email] = @email

      if @user.save
        User.delete(@user.id)
        redirect_to user_company_exist_users_path(:name => @company)
      else
        render :register
      end
    elsif @status.present?
      @user.name = @name
      @user.email = @email
      @user.password = @password
      @user.confirmed_password = @password
      @user.role_type = 'Admin'
      if @user.save

        tender_id = params[:tender_id]

        if tender_id.present?
          user_tender = UserTender.new
          user_tender.user_id = @user.id
          user_tender.tender_id = tender_id
          user_tender.save
        end

        company = Company.new
        company.name = @company
        company.user_id = @user.id
        company.save

        UserPlan.where(:user_id => @user.id).destroy_all
        user_plan = UserPlan.new
        user_plan.user_id = @user.id
        user_plan.plan = 'STARTER PLAN $0'
        user_plan.amount = 0.00
        user_plan.save

        TenderconMailer.delay.registration_email(@user.email,root_url,@user.id,@user.unique_key)
        User.delay(run_at: 20.minutes.from_now).execute_token_expiration(@user.id)
        flash[:notice] = "Your account has been successfully created."
        redirect_to registration_completed_users_path(:id => @user.id)
      else
        render :register
      end
    else
      @user.role_type = 'Admin'
      if @user.save
        company = Company.new
        company.name = @company
        company.user_id = @user.id
        company.save

        UserPlan.where(:user_id => @user.id).destroy_all
        user_plan = UserPlan.new
        user_plan.user_id = @user.id
        user_plan.plan = 'STARTER PLAN $0'
        user_plan.amount = 0.00
        user_plan.save

        tender_id = params[:tender_id]

        if tender_id.present?
          user_tender = UserTender.new
          user_tender.user_id = @user.id
          user_tender.tender_id = tender_id
          user_tender.save
        end

        TenderconMailer.registration_email(@user.email,root_url,@user.id,@user.unique_key).deliver_now
        User.delay(run_at: 20.minutes.from_now).execute_token_expiration(@user.id)
        flash[:notice] = "You account successfully created."
        redirect_to registration_completed_users_path(:id => @user.id)
      else
        render :register
      end
    end
  end

  def update
    @user = User.find(params[:id])

    #if @user.avatar
    #  @user.avatars.each do |a|
    #    @avatar_id = a.id
    #    @avatar_filename = a.image_file_name
    #    @link = "http://"+request.host_with_port+"/assets/avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
    #  end
    #end

    name = params[:name].split(' ')
    email = params[:email]
    mobile_number = params[:mobile]
    position = params[:position]

    pos = Position.where(:title => position).first

    if pos.present?
      @new_user_position = pos.id
    else
      new_position = Position.new
      new_position.title = position
      new_position.status = 1
      new_position.save
      @new_user_position = new_position.id
    end

    about_me = params[:about_me]
    linkedin = params[:linkedin]
    if about_me.present? || linkedin.present?

      UserInfo.where(:user_id => @user.id).destroy_all

      user_info = UserInfo.new
      user_info.about_me = about_me
      user_info.linkedin = linkedin
      user_info.user_id = @user.id
      user_info.save
    end
    puts "TEST+++++++++> #{@user.id}"

    if User.where(:id => @user.id).update_all(:position => @new_user_position,
      :email => email,
      :first_name => name[0],
      :last_name => name[1],
      :mobile_number => mobile_number)


      if params[:avatar].present?

        if @user.avatar.present?
          @user.avatar.update_attributes(:image => params[:avatar])
        else
          @avatar = Avatar.new
          @avatar.image = params[:avatar]
          @avatar.user_id = @user.id
          @avatar.save
        end

      end

      if about_me.present? && linkedin.present? && @avatar_id.present?
        flash[:notice] = "Well Done! Your Profile is 100% Updated!"
      else
        flash[:notice] = "User profile updated."
      end


      redirect_to profile_users_path(:id => @user.id)
    end

  end

  def update_info
    user = User.find(session[:user_logged_id])

    if user.present?
      User.where(:id => user.id).update_all(:first_name => params[:f_name],
                                            :last_name => params[:l_name],
                                            :email => params[:email],
                                            :trade_name => params[:trade_name],
                                            :mobile_number => params[:mobile],
                                            :position => params[:position])
      user_info = UserInfo.where(:user_id => user.id)

      if user_info.present?
        UserInfo.where(:user_id => user.id).update_all(:about_me => params[:about], :linkedin => params[:linkedin])
      else
        u_info = UserInfo.new
        u_info.user_id = user.id
        u_info.about_me = params[:about]
        u_info.linkedin = params[:linkedin]
        u_info.save
      end



      if params[:location].present?
        address = Address.where(:user_id => user.id)

        if address.present?
          Address.where(:user_id => user.id).update_all(:location => params[:location])
        else
          add = Address.new
          add.user_id = user.id
          add.location = params[:location]
          add.save
        end

      end

      render :json => { :state => 'valid'}
    end
  end

  def profile_update_password
    user = User.find(session[:user_logged_id])

    if user.password != (User.rehash_password(params[:current_pass]))
      render :json => { :state => 'old_password'}
    elsif  user.password == (User.rehash_password(params[:current_pass]))  && params[:new_pass] != params[:confirmed]
      render :json => { :state => 'not_match'}
    else
      User.where(:id => user.id).update_all(:password =>  User.rehash_password(params[:new_pass]),
                                            :confirmed_password => User.rehash_password(params[:new_pass]))
      render :json => { :state => 'valid'}
    end
  end


  def update_user
    # Address Table
    state = params[:state]
    suburb = params[:suburb]
    postcode = params[:postcode]
    location = params[:address]
    timezone = params[:timezone]

    # User Table
    abn = params[:abn].delete(' ')
    company = params[:company]
    first_name = params[:first_name]
    last_name = params[:last_name]
    tendercon_id = params[:tendercon_id]
    position = params[:position]
    user_id = params[:user_id]
    trade_name = params[:trade_name]

    # Primary Trade
    primary_trade = params[:primary_trade]

    # Secondary Trade
    trade_array = []
    secondary_value1 = params[:secondary_value1]
    secondary_value2 = params[:secondary_value2]
    secondary_value3 = params[:secondary_value3]
    secondary_value4 = params[:secondary_value4]
    secondary_value5 = params[:secondary_value5]
    secondary_value6 = params[:secondary_value6]


    if secondary_value1.to_i > 0
      trade_array << secondary_value1.to_i
    end

    if secondary_value2.to_i > 0
      trade_array << secondary_value2.to_i
    end

    if secondary_value3.to_i > 0
      trade_array << secondary_value3.to_i
    end

    if secondary_value4.to_i > 0
      trade_array << secondary_value4.to_i
    end

    if secondary_value5.to_i > 0
      trade_array << secondary_value5.to_i
    end

    if secondary_value6.to_i > 0
      trade_array << secondary_value6.to_i
    end

    @user = User.find(user_id)
    puts "position.to_i > 0:#{position =~ /\A\d+\z/ ? true : false}"
    if User.where(:id => user_id).update_all(:abn => abn,
       :company => company,
       :first_name => first_name,
       :last_name => last_name,
       :tendercon_id => tendercon_id,
       :tendercon_key => User.execute_tendercon_key,
       :trade_name => trade_name )

      Company.where(:user_id => user_id).update_all(:name => trade_name)

      address = Address.new
      address.state = state
      address.location = location
      address.postcode = postcode
      address.suburb = suburb
      address.timezone = timezone
      address.user_id = user_id
      address.save
      pos = (position =~ /\A\d+\z/ ? true : false)
      puts "POS:#{pos}"

      if pos
        User.where(:id => user_id).update_all(:position => position)
      else
        new_position = Position.new
        new_position.title = position
        new_position.status = 1
        new_position.save
        User.where(:id => user_id).update_all(:position => new_position)
        TenderconMailer.sent_new_position_email_to_admin(@user.email,user_id,position).deliver_now
      end

      prime =  (primary_trade =~ /\A\d+\z/ ? true : false)
      puts "PRIME:#{prime}"
      if primary_trade.present?

        if prime
          primary = PrimaryTrade.new
          primary.trade_id = primary_trade
          primary.user_id = user_id
          primary.save
        else
          trade = Trade.new
          trade.name = primary_trade
          trade.status = 1
          trade.save

          primary = PrimaryTrade.new
          primary.trade_id = trade.id
          primary.user_id = user_id
          primary.save
          TenderconMailer.sent_new_trade_email_to_admin(@user.email,user_id,primary_trade).deliver_now
        end
      end

      if trade_array.present?
        trade_array.uniq.each do |t|
          secondary = SecondaryTrade.new
          secondary.trade_id = t
          secondary.user_id = user_id
          secondary.save
        end
      end

      TenderconCode.where(:name => tendercon_id).destroy_all

      TenderconMailer.welcome_email(@user.email,@user.id).deliver_now
      render :json => { :state => 'valid'}
    else
      render :json => { :state => 'invalid'}
    end
  end

  def steps_completed


  end

  def user_company_exist
    @name = params[:name]
    @companies = Company.where(:name => @name)

    @email = session[:email]
    @password = session[:password]
    @user_name = session[:name]
  end

  def account_taken
    @id = params[:id]
    @company = Company.find(@id)
  end


  def registration_completed
   @id = params[:id]
  end

  def resent_email_notification
    id = params[:id]
    user = User.find(id)

    if user.present?
      TenderconMailer.registration_email(user.email,root_url,user.id,user.unique_key).deliver_now
      flash[:notice] = "Resending activation email success."
    else
      flash[:erro] = "Account doesn't exist."
    end

    redirect_to :back
  end

  def validate_user_email
    user = User.where(:email => params[:email]).count()

    if user > 0
      render :json => { :state => 'invalid'}
    else
      render :json => { :state => 'valid'}
    end
  end

  def authenticate
    activated = params[:new_account]
    user_id = params[:id]
    @email = params[:email]
    password = params[:password]
    if activated.present? && user_id.present?
      new_user = User.find(user_id)
      @user = User.where(:email => new_user.email, :password => new_user.password,:verified => 1,:status => nil).first
    else
      if params[:credit_card].present? || params[:invites].present?
        @user = User.where(:email => @email).first
      else
        puts "PASSWORD ====> #{params[:password]}"
        puts "EMAIL ====> #{params[:email]}"
        hash_password = User.rehash_password password
        puts "hash_password:#{hash_password}"
        @user = User.where(:email => @email, :password => hash_password,:verified => true,:status => nil).first
        puts "USER =========> #{@user.inspect}"
        #if params[:email].strip == 'agile.jjp@gmail.com'.strip
        #  @user = User.find(6)
        #elsif  params[:email].strip == 'joe_dhay@yahoo.com'.strip
        #  @user = User.find(7)
        #else
        #  @user = User.where(:email => @email.strip, :password => hash_password,:verified => true,:status => nil).first
        #end
        puts "USERS ALL ==============> #{User.all.inspect}"
      end
    end


    if @user.present?
      session[:role] = @user.role
      session[:time_logged] = Time.now + 1.week
      session[:name] = "#{@user.first_name} #{@user.last_name}"
      session[:user_logged_id] = @user.id
      session[:email] = @user.email
      session[:company] = @user.company
      session[:role_type] = @user.role_type
      log_user = (@user.logged_count).to_i + 1
      session[:original_url] = nil
      User.where(:id => @user.id).update_all(:logged_count => log_user,:error_logs => 0,:logged_status => 'online')
      if params[:url].present?
        redirect_to params[:url]
      elsif params[:link].present?
        redirect_to params[:link]
      else
        if @user.role != 'Admin'
          if @user.abn.present? && @user.tendercon_id.present?
            if params[:credit_card].present?
              redirect_to billing_users_path
            else
              if params[:tender].present?
                puts "TENDER ========> #{params[:tender]}"
                redirect_to '/tenders/invited_tender'
              else
                redirect_to dashboard_index_path
              end


            end
          else
            if params[:invites].present?
              redirect_to tendercon_steps_users_path(:id => @user.id,:invites => true)
            else
              redirect_to welcome_page_users_path(:id=>@user.id)
            end

          end
        else
          redirect_to dashboard_index_path
        end


      end
    else
      user_log = User.where(:email => @email).first
      if user_log.present? && !params[:link].present?
        new_error_log = (user_log.error_logs).to_i + 1
        new_user_log = User.find(user_log.id)
        User.where(:id => user_log.id).update_all(:error_logs => new_error_log.to_i)


        if (new_user_log.error_logs).to_i >= 5
          link = "#{view_context.link_to('Forgot Password',forgot_password_users_path)}".html_safe
          flash[:error] = "Opps! You've poked bear one too many times. Please contact support at support@tendercon.com(Tendercon) or click #{link} to reset password."
        else
          flash[:error] = "Invalid credentials. Please try again."
        end
        #redirect_to :back
        puts "1"
        #render :login
        redirect_to login_users_path
      elsif params[:link].present?
        puts "2"
        flash[:error] = "Invalid credentials. Please try again."
        redirect_to logout_users_path
      else
        puts "3"
        flash[:error] = "Invalid credentials. Please try again."
        redirect_to :back
        #render :login
      end

    end
  end

  def welcome_page

  end

  def tendercon_steps

    @user = User.find(params[:id])
    @availabilities = TimeAvailability.all

    if @user.companies.present?
      @user.companies.each do |comp|
        @company = comp.name
      end
    end
    @trades = Trade.all
    @tender_code = TenderconCode.first
    @positions = Position.all
  end

  def check_abn
    str_abn = params[:str].delete(' ')
    @resp = false
    users = User.where(:abn => str_abn)

    puts "is_number? str:#{User.is_number? str_abn}"

    if users.present?
      @resp = false
      @error = 'ABN already exists on the system.'
    else

      if (User.is_number? str_abn)
        abn = ABNSearch.new(ENV['ABN_GUID'])
        result = abn.search(str_abn)
        puts "ABN:#{abn.inspect}"
        puts "RESULT:#{result.inspect}"
        if result.present?
          begin
            @resp = true
            puts result[:abn]
            @name = result[:name]

          rescue
            @resp = false
            puts "Error"
            @error = 'Invalid ABN'
          end
        end
      else
        @resp = false
        @error = 'ABN ID should contain numbers only.'
      end
    end

    puts "@resp:#{@resp}"

    if @resp
      if (@name == 'Name unknown') || (@name.include? 'unknown')
        render :json => { :state => 'invalid',:error => @error}
      else
        render :json => { :state => 'valid',:company_name => @name}
      end

    else
      render :json => { :state => 'invalid',:error => @error}
    end


  end

  def forgot_password

  end

  def profile
    @user = User.find(params[:id])
    @avatar = Avatar.new
    #if @user.avatars
    #  @user.avatars.each do |a|
    #    puts "ID:#{a.id}"
    #    @avatar_id = a.id
    #    @avatar_filename = a.image_file_name
    #    @link = "http://"+request.host_with_port+"/assets/avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
    #  end
    #end

    if @user.user_info
      #@user.user_infos.each do |a|
        # puts "ID:#{a.id}"
        # @linkedin = a.linkedin
        # @about_me = a.about_me
      #end
    end
  end

  def edit_profile
    @user = User.find(params[:id])
    @avatar = Avatar.new

    #if @user.avatars
    #  @user.avatars.each do |a|
    #    puts "ID:#{a.id}"
    #    @avatar_id = a.id
    #    @avatar_filename = a.image_file_name
    #    @link = "http://"+request.host_with_port+"/assets/avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
    #  end
    #end

    if @user.user_info
      # @user.user_info.each do |a|
      #   puts "ID:#{a.id}"
      #   @linkedin = a.linkedin
      #   @about_me = a.about_me
      # end
    end
  end

  def company_profile
    @company_profile = CompanyProfile.new
    @user = User.find(session[:user_logged_id])
    @added_company_profile = CompanyProfile.where(:user_id => @user.id).first

    if @added_company_profile.present?
      @about_me = @added_company_profile.about_me
      puts "@about_me1:#{@about_me.present?}"
    end

    if @added_company_profile.present?
      if @added_company_profile.project_range.present?
        @p_to = @added_company_profile.project_range.split('-')
      end
    end

    @primary_trade = PrimaryTrade.where(:user_id => @user.id).first
    @secondary_trades = SecondaryTrade.where(:user_id => @user.id)
    @secondary_trade_array = []
    if @secondary_trades.present?
      @secondary_trades.each do |s|
        @secondary_trade_array << s.trade_id
      end
    end

    @trades = Trade.all

    @company_avatar = CompanyAvatar.new
    # if @user.company_avatars
    #   @user.company_avatars.each do |a|
    #     @avatar_id = a.id
    #     @avatar_filename = a.image_file_name
    #     @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
    #   end
    # end

    @years = []
    @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
    @to = ['','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

    for i in 1800..(Time.now.strftime('%Y').to_i) do
      @years << i
    end
  end



  def edit_company_profile
    @company_profile = CompanyProfile.new
    @user = User.find(session[:user_logged_id])
    @added_company_profile = CompanyProfile.where(:user_id => @user.id).first

    if @added_company_profile.present?
      @about_me = @added_company_profile.about_me
      puts "@about_me1:#{@about_me.present?}"
    end

    if @added_company_profile.present?
      if @added_company_profile.project_range.present?
        @p_to = @added_company_profile.project_range.split('-')
      end
    end

    @primary_trade = PrimaryTrade.where(:user_id => @user.id).first
    @secondary_trades = SecondaryTrade.where(:user_id => @user.id)
    @secondary_trade_array = []
    if @secondary_trades.present?
      @secondary_trades.each do |s|
        @secondary_trade_array << s.trade_id
      end
    end

    @trades = Trade.all

    @company_avatar = CompanyAvatar.new
    # if @user.company_avatars
    #   @user.company_avatars.each do |a|
    #     @avatar_id = a.id
    #     @avatar_filename = a.image_file_name
    #     @link = "http://"+request.host_with_port+"/assets/company_avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
    #   end
    # end

    @years = []
    @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
    @to = ['','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

    for i in 1800..(Time.now.strftime('%Y').to_i) do
      @years << i
    end
  end

  def create_company_profile
    @company_profile = CompanyProfile.where(:user_id => params[:user_id]).first
    to = params[:to]
    from = params[:from]
    project_range = "#{from}-#{to}"

    if @company_profile.present?

      CompanyProfile.where(:user_id => params[:user_id]).update_all(
          :about_me => params[:about_me],
          :number_of_employees => params[:number_of_employees],
          :commenced_operation => params[:commenced_operation],
          :since => params[:since],
          :project_range => project_range,
          :contact_number => params[:contact_number],
          :fax_number => params[:fax_number],
          :website => params[:website],
          :linkedin => params[:linkedin],
          :facebook => params[:fb],
          :acn => params[:acn]
      )

      if params[:suburb].present?
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address],:suburb => params[:suburb],:postcode => params[:postcode],:state => params[:state], :timezone => params[:timezone])
      else
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address])
      end

      PrimaryTrade.where(:user_id => params[:user_id]).destroy_all

      primary = PrimaryTrade.new
      primary.trade_id = params[:primary_trade]
      primary.user_id = params[:user_id]
      primary.save

      SecondaryTrade.where(:user_id => params[:user_id]).destroy_all

      s_array = []

      if params[:secondary_trade1].present? && params[:secondary_trade1].to_i > 0
        s_array << params[:secondary_trade1]
      end

      if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
        s_array << params[:secondary_trade2]
      end

      if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
        s_array << params[:secondary_trade3]
      end

      if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
        s_array << params[:secondary_trade4]
      end

      if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
        s_array << params[:secondary_trade5]
      end


      if s_array.present?
        s_array.each do |s|
          secondary = SecondaryTrade.new
          secondary.trade_id = s
          secondary.user_id = params[:user_id]
          secondary.save
        end
      end
    else
      @company_profile = CompanyProfile.new
      @company_profile.user_id = params[:user_id]
      @company_profile.about_me = params[:about_me]
      @company_profile.number_of_employees = params[:number_of_employees]
      @company_profile.commenced_operation = params[:commenced_operation]
      @company_profile.since = params[:since]
      @company_profile.project_range = project_range
      @company_profile.contact_number = params[:contact_number]
      @company_profile.fax_number = params[:fax_number]
      @company_profile.website = params[:website]
      @company_profile.linkedin = params[:linkedin]
      @company_profile.facebook = params[:fb]
      @company_profile.acn = params[:acn]
      @company_profile.save


      if params[:suburb].present?
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address],:suburb => params[:suburb],:postcode => params[:postcode],:state => params[:state], :timezone => params[:timezone])
      else
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address])
      end

      PrimaryTrade.where(:user_id => params[:user_id]).destroy_all

      primary = PrimaryTrade.new
      primary.trade_id = params[:primary_trade]
      primary.user_id = params[:user_id]
      primary.save

      SecondaryTrade.where(:user_id => params[:user_id]).destroy_all

      s_array = []

      if params[:secondary_trade1].present? && params[:secondary_trade1].to_i > 0
        s_array << params[:secondary_trade1]
      end

      if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
        s_array << params[:secondary_trade2]
      end

      if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
        s_array << params[:secondary_trade3]
      end

      if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
        s_array << params[:secondary_trade4]
      end

      if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
        s_array << params[:secondary_trade5]
      end

      if s_array.present?
        s_array.each do |s|
          secondary = SecondaryTrade.new
          secondary.trade_id = s
          secondary.user_id = params[:user_id]
          secondary.save
        end
      end

    end
    redirect_to company_profile_users_path(:id => params[:user_id])
  end

  def update_company_info
    @company_profile = CompanyProfile.where(:user_id => session[:user_logged_id]).first
    to = params[:to]
    from = params[:from]
    project_range = "#{from}-#{to}"

    User.where(:id => session[:user_logged_id]).update_all(:trade_name => params[:trade_name])

    if @company_profile.present?

      CompanyProfile.where(:user_id => session[:user_logged_id]).update_all(
          :about_me => params[:about_me],
          :number_of_employees => params[:number_of_employees],
          :commenced_operation => params[:commenced_operation],
          :since => params[:since],
          :project_range => project_range,
          :contact_number => params[:contact_number],
          :fax_number => params[:fax_number],
          :website => params[:website],
          :linkedin => params[:linkedin],
          :facebook => params[:fb],
          :acn => params[:acn]
      )

      if params[:suburb].present?
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address],:suburb => params[:suburb],:postcode => params[:postcode],:state => params[:state], :timezone => params[:timezone])
      else
        Address.where(:user_id => params[:user_id]).update_all(:location => params[:address])
      end

      PrimaryTrade.where(:user_id => session[:user_logged_id]).destroy_all

      primary = PrimaryTrade.new
      primary.trade_id = params[:primary_trade]
      primary.user_id = session[:user_logged_id]
      primary.save

      SecondaryTrade.where(:user_id => session[:user_logged_id]).destroy_all

      s_array = []

      if params[:secondary_trade1].present? && params[:secondary_trade1].to_i > 0
        s_array << params[:secondary_trade1]
      end

      if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
        s_array << params[:secondary_trade2]
      end

      if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
        s_array << params[:secondary_trade3]
      end

      if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
        s_array << params[:secondary_trade4]
      end

      if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
        s_array << params[:secondary_trade5]
      end


      if s_array.present?
        s_array.each do |s|
          secondary = SecondaryTrade.new
          secondary.trade_id = s
          secondary.user_id = session[:user_logged_id]
          secondary.save
        end
      end
    else
      @company_profile = CompanyProfile.new
      @company_profile.user_id = session[:user_logged_id]
      @company_profile.about_me = params[:about_me]
      @company_profile.number_of_employees = params[:number_of_employees]
      @company_profile.commenced_operation = params[:commenced_operation]
      @company_profile.since = params[:since]
      @company_profile.project_range = project_range
      @company_profile.contact_number = params[:contact_number]
      @company_profile.fax_number = params[:fax_number]
      @company_profile.website = params[:website]
      @company_profile.linkedin = params[:linkedin]
      @company_profile.facebook = params[:fb]
      @company_profile.acn = params[:acn]
      @company_profile.save


      if params[:suburb].present?
        Address.where(:user_id => session[:user_logged_id]).update_all(:location => params[:address],:suburb => params[:suburb],:postcode => params[:postcode],:state => params[:state], :timezone => params[:timezone])
      else
        Address.where(:user_id => session[:user_logged_id]).update_all(:location => params[:address])
      end

      PrimaryTrade.where(:user_id => session[:user_logged_id]).destroy_all

      primary = PrimaryTrade.new
      primary.trade_id = params[:primary_trade]
      primary.user_id = session[:user_logged_id]
      primary.save

      SecondaryTrade.where(:user_id => session[:user_logged_id]).destroy_all

      s_array = []

      if params[:secondary_trade1].present? && params[:secondary_trade1].to_i > 0
        s_array << params[:secondary_trade1]
      end

      if params[:secondary_trade2].present? && params[:secondary_trade2].to_i > 0
        s_array << params[:secondary_trade2]
      end

      if params[:secondary_trade3].present? && params[:secondary_trade3].to_i > 0
        s_array << params[:secondary_trade3]
      end

      if params[:secondary_trade4].present? && params[:secondary_trade4].to_i > 0
        s_array << params[:secondary_trade4]
      end

      if params[:secondary_trade5].present? && params[:secondary_trade5].to_i > 0
        s_array << params[:secondary_trade5]
      end

      if s_array.present?
        s_array.each do |s|
          secondary = SecondaryTrade.new
          secondary.trade_id = s
          secondary.user_id = session[:user_logged_id]
          secondary.save
        end
      end

    end
    render :json => { :state => 'valid'}
  end

  def update_company_avatar
    user = User.find(session[:user_logged_id])

    if params[:avatar].present?
      if user.company_avatar.present?
        user.company_avatar.update_attributes(:image => params[:avatar])
      else
        if params[:avatar].present?
          avatar = CompanyAvatar.new
          avatar.image = params[:avatar]
          avatar.user_id = session[:user_logged_id]
          avatar.save
        end
      end

      render :json => { :state => 'valid',:avatar_url => user.company_avatar.image.url(:original)}
    else
      render :json => { :state => 'invalid'}
    end




  end

  def create_company_avatar
    avatar = CompanyAvatar.new(company_avatar_premitted_params)

    CompanyAvatar.where(:user => params[:company_avatar][:user_id]).destroy_all

    if avatar.save
      url = request.host_with_port+"/assets/company_avatar/image/#{avatar.id}/original/#{avatar.image_file_name}"
      puts "AVATAR:#{url}"
      render :json => { :state => 'valid',:avatar_url => url}
    else
      render :json => { :state => 'invalid',:errors => 'Image should be jpg and png. And maximum of 1mb.'}
    end

  end

  def create_avatar
    avatar = Avatar.new(avatar_premitted_params)

    Avatar.where(:user => params[:avatar][:user_id]).destroy_all

    if avatar.save
      url = request.host_with_port+"/assets/avatar/image/#{avatar.id}/original/#{avatar.image_file_name}"
      puts "AVATAR:#{url}"
      render :json => { :state => 'valid',:avatar_url => url}
    else
      render :json => { :state => 'invalid',:errors => 'Image should be jpg and png only. And maximum of 1mb.'}
    end

  end

  def upload_image
    filename = params[:filename]

  end


  def email_authentication
    email =  params[:email]
    
    user = User.where(:email => email).first
    
    if user.present?
      TenderconMailer.reset_password(user.email,request.host_with_port,user.id).deliver_now
      redirect_to validation_complete_users_path(:email => email)
    else
      flash[:error] = "Opps: We couldn't find that email address."
      render :forgot_password
    end
  end

  def validation_complete

  end

  def reset_password

  end

  def update_password
    password = params[:password]
    confirm_password = params[:confirmed_password]
    @id = params[:user_id]
    @email = params[:email]

    @status = params[:status]

    if password == confirm_password
      user = User.validate_password password

      if user == 'length'
        flash[:error] = "Password must atleast 8 characters. Please try again."
        if @status.present?
          redirect_to change_password_users_path
        else
          render :reset_password
        end

      elsif user == 'number'
        flash[:error] = "Password must contain at least a single number. Please try again."
        if @status.present?
          redirect_to change_password_users_path
        else
          render :reset_password
        end
      elsif user == 'letter'
        flash[:error] = "Password must contain at least a single capital letter. Please try again."
        if @status.present?
          redirect_to change_password_users_path
        else
          render :reset_password
        end

      else

        @user = User.find(@id)
        new_password = User.rehash_password password
        new_confirmed_password = User.rehash_password password
        puts "PASSWORD:#{new_password}"
        if @user.present?
          User.where(:id => @id).update_all(:password => new_password,:confirmed_password => new_confirmed_password,:error_logs => 0)

          if @status.present?
            flash[:notice] = "Please re-login and use your new password."
            TenderconMailer.reset_password_confirmation(@user.email,@user.id).deliver_now
            redirect_to logout_users_path
          else
            TenderconMailer.reset_password_confirmation(@user.email,@user.id).deliver_now
            redirect_to password_changed_users_path
          end

        end
      end
    else
      flash[:error] = "Opps: Your passwords do not match"

      if @status.present?
        redirect_to change_password_users_path
      else
        render :reset_password
      end
    end
  end

  def password_changed

  end

  def validate_account
    id = params[:id]
    user = User.find(id)

    if user.present?
      if user.unique_key.present?
        User.where(:id => user.id).update_all(:verified => true)
        redirect_to authenticate_users_path(:id => id, :new_account => 'activated')
      else
        redirect_to token_expired_users_path(:id => user.id)
      end
    else
      flash[:error] = "No user exist. Please register new account."
      redirect_to register_users_path
    end
  end

  def validate_trade
    new_trade = params[:trade]

    upper_case = new_trade.upcase
    lower_case = new_trade.downcase
    upcase_first_letter = new_trade.titleize

    trades = Trade.where(" name = '#{upper_case}' OR name = '#{lower_case}' OR name = '#{upcase_first_letter}' ")

    if trades.present?
      render :json => { :state => 'invalid'}
    else
      render :json => { :state => 'valid',:title => new_trade}
    end

  end

  def token_expired

  end

  def generate_new_token
    id = params[:id]
    user = User.find(id)

    if user.present?
      User.where(:id => user.id).update_all(:unique_key => Digest::MD5.hexdigest(user.email+"Admin"))
      TenderconMailer.registration_email(user.email,root_url,user.id,user.unique_key).deliver_now
      User.delay(run_at: 20.minutes.from_now).execute_token_expiration(user.id)
      flash[:notice] = "New email was sent. Please check your email."
      redirect_to :back
    end
  end

  def get_position_value
    id = params[:id]

    position = Position.find(id)

    if position.present?
      render :json => { :state => 'valid',:title => position.title}
    else
      render :json => { :state => 'invalid'}
    end
  end

  def get_trade_value
    id = params[:id]
    if id.to_i > 0
      trade = Trade.find(id)
      if trade.present?
        render :json => { :state => 'valid',:title => trade.name}
      else
        render :json => { :state => 'invalid'}
      end
    else
      render :json => { :state => 'invalid'}
    end

  end


  def validate_position
    title = params[:position]

    upper_case = title.upcase
    lower_case = title.downcase
    upcase_first_letter = title.titleize

    position = Position.where(" title = '#{upper_case}' OR title = '#{lower_case}' OR title = '#{upcase_first_letter}' ")
    positions = Position.all
    titles = []
    if positions.present?
      positions.each do |p|
        titles << p.title
      end
    end


    if position.present?
      render :json => { :state => 'invalid'}
    else
      render :json => { :state => 'valid',:positions => titles}
    end
  end


  def get_positions
    positions = Position.all
    titles = []
    if positions.present?
      positions.each do |p|
        titles << p.title
      end
    end

    if positions.present?
      render :json => { :state => 'valid',:positions => titles}
    else
      render :json => { :state => 'invalid'}
    end
  end

  def validate_tendercon_id
    code = params[:code]
    user = User.where(:tendercon_id => code)

    if user.present?
      render :json => { :state => 'invalid'}
    else
      render :json => { :state => 'valid'}
    end
  end

  def get_similar_address
    str = params[:str]

    require 'open-uri'
    response = open("http://api.addressify.com.au/address/autoComplete?api_key=08ae9fb1-25be-440e-adae-5134c2684e5a&term=#{str}+&max_results=10").read
    puts "response:#{response.split('"').to_a}"
    new_arr = response.split('"').to_a

    response_array = []

    if new_arr.present?
      new_arr.each do |r|
        if r.size > 3
          response_array << r
        end

      end
    end
    puts "response:#{response_array.inspect}"
    array_json = []
    if response_array.present?
      response_array.each do |m|
        #array_json << JSON.parse({:name =>  m }.to_json)
        array_json << m
      end
    end
    puts "array_json:#{array_json}"
    if response.present?
      render :json => { :state => 'valid', :data => array_json}
    else
      render :json => { :state => 'invalid'}
    end
  end

  def get_address_info
    require 'timezone'
    address = params[:address]

    begin
      user_loc = Geocoder.search(address)
      user_address = Geocoder.coordinates(address)

      response2 = open("https://maps.googleapis.com/maps/api/timezone/json?location=#{user_address[0]},#{user_address[1]}&timestamp=1458000000&key=AIzaSyA7B-_hoQVA07h-qSd3E-HXxyXnM9W4zC8").read

      new_response = JSON.parse response2
      Time.zone = new_response['timeZoneId']

      new_timezone = (Time.zone.to_s).split(' ')


      user_loc[0].address_components.each do |a|

        if a['types'][0] == 'locality'
          @suburb = a['long_name']
        end
      end

      @latitue =  user_address[0]
      @longitude = user_address[1]
      puts "latitude:#{@latitue}"
      t = Timezone[new_response['timeZoneId']]
      now =  t.utc_to_local(Time.now).strftime('%H:%M:%S')
      puts "new_response['timeZoneName'].to_s =====>#{new_response['timeZoneName'].to_s}"
      real_timezone =  new_timezone[0].tr('()', '') + " " + "(#{(new_response['timeZoneName'].to_s)})"
      puts "user_loc.first.postal_code ======> #{real_timezone.inspect}"
      if user_loc.first.postal_code.present?
        render :json => { :state => 'valid', :postal => user_loc.first.postal_code,:add_state =>  user_loc.first.state, :suburb =>@suburb,:timezone => real_timezone, :latitude => @latitue, :longitude => @longitude}
      else
        render :json => { :state => 'invalid'}
      end
    rescue
      user_loc = Geocoder.search(address)
      user_address = Geocoder.coordinates(address)

      if user_address.present?
        user_loc[0].address_components.each do |a|

          if a['types'][0] == 'locality'
            @suburb = a['long_name']
          end
        end
        response2 = open("https://maps.googleapis.com/maps/api/timezone/json?location=#{user_address[0]},#{user_address[1]}&timestamp=1458000000&key=AIzaSyA7B-_hoQVA07h-qSd3E-HXxyXnM9W4zC8").read

        new_response = JSON.parse response2
        Time.zone = new_response['timeZoneId']

        new_timezone = (Time.zone.to_s).split(' ')
        @latitue =  user_address[0]
        @longitude = user_address[1]


        t = Timezone[new_response['timeZoneId']]
        now =  t.utc_to_local(Time.now).strftime('%H:%M:%S')

        real_timezone = now.to_s + " " + new_timezone[0].tr('()', '') + " " + "(#{(new_response['timeZoneName'].to_s)})"
        puts "user_loc.first.inspect:#{user_loc.first.inspect}"
        if user_loc.first.postal_code.present?
          render :json => { :state => 'valid', :postal => user_loc.first.postal_code,:add_state =>  user_loc.first.state, :suburb =>@suburb,:timezone => real_timezone, :latitude => @latitue, :longitude => @longitude}
        else
          render :json => { :state => 'invalid'}
        end
      else
        puts "INVALID"
        render :json => { :state => 'invalid'}
      end


    end
  end

  def submit_request
    id = params[:id]
    email = params[:email]
    first = params[:first]
    second = params[:second]
    third = params[:third]
    time_availabity = params[:time_availabity]
    contact_number = params[:contact]
    time = TimeAvailability.find(time_availabity)

    if contact_number.present?
      User.where(:id =>id).update_all(:status => 'suspended')
      TenderconMailer.user_request_to_admin(email,id,first,second,third,time.availability,contact_number).deliver_now
      TenderconMailer.user_request_to_admin_copy(email,id,first,second,third,time.availability,contact_number).deliver_now
    else
      user = User.find(id)
      TenderconMailer.delete_email(user.email,user.id).deliver_now
      if user.present?
        if user.destroy
          Address.where(:user_id => id).destroy_all
        end
      end

      session[:role] = nil
      session[:time_logged] = nil
      session[:name] = nil
      session[:user_logged_id] = nil
      session[:email] = nil

    end
    if params[:status].present?
      render :json => { :state => 'valid'}
    else
      flash[:error] = "Tendercon Team will be in touch on you as soon as possible.You account is temporary suspended."
      redirect_to logout_users_path
    end
  end

  def update_user_div
    id = params[:id]

    if User.where(:id => id).update_all(:div_status => true)
      redirect_to :back
    end
  end

  def validate_linkedin
    linkedin_url = params[:link]

    begin
      profile = Linkedin::Profile.new(linkedin_url)

      if profile.present?
        render :json => { :state => 'valid'}
      end
    rescue

      profile = Linkedin::Profile.new(linkedin_url)

      if profile.present?
        render :json => { :state => 'valid'}
      else
        render :json => { :state => 'invalid'}
      end
    end
  end

  def change_password
    @user = User.find(session[:user_logged_id])
  end

  def download_profile

    respond_to do |format|
      format.html
      format.pdf do
        @user = User.find(session[:user_logged_id])
        @avatar = Avatar.new

        if @user.avatars
          @user.avatars.each do |a|
            @avatar_id = a.id
            @avatar_filename = a.image_file_name

          end
        end

        if @user.user_infos
          @user.user_infos.each do |a|
            @linkedin = a.linkedin
            @about_me = a.about_me
          end
        end
        @link = "#{Rails.root}/public/assets/avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
        @pdf = Prawn::Document.new(options={:page_layout => :portrait})
        @pdf = ProfilePdf.new(@link,@linkedin,@about_me,session[:user_logged_id])
        send_data @pdf.render, :filename => "#{@user.first_name}#{@user.last_name}ProfileTendercon.pdf", :type => "application/pdf"
      end
    end
  end


  def hc_download_profile

    respond_to do |format|
      format.html
      format.pdf do
        @user = User.find(session[:user_logged_id])
        @avatar = Avatar.new

        if @user.company_avatars.present?
          @user.company_avatars.each do |a|
            @avatar_id = a.id
            @avatar_filename = a.image_file_name
          end
        end
        @added_company_profile = CompanyProfile.where(:user_id => @user.id).first
        if @added_company_profile.present?

            @about_me = @added_company_profile.about_me

        end
        @link = "#{Rails.root}/public/assets/company_avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
        @pdf = Prawn::Document.new(options={:page_layout => :portrait})
        @pdf = HcCompanyProfilePdf.new(@link,@about_me,session[:user_logged_id])
        send_data @pdf.render, :filename => "#{@user.first_name}#{@user.last_name}CompanyTendercon.pdf", :type => "application/pdf"
      end
    end
  end

  def sc_download_profile

    respond_to do |format|
      format.html
      format.pdf do
        @user = User.find(session[:user_logged_id])
        @avatar = Avatar.new

        if @user.company_avatars.present?
          @user.company_avatars.each do |a|
            @avatar_id = a.id
            @avatar_filename = a.image_file_name
          end
        end
        @added_company_profile = CompanyProfile.where(:user_id => @user.id).first
        if @added_company_profile.present?

          @about_me = @added_company_profile.about_me

        end
        @link = "#{Rails.root}/public/assets/company_avatar/image/#{@avatar_id}/original/#{@avatar_filename}"
        @pdf = Prawn::Document.new(options={:page_layout => :portrait})
        @pdf = ScCompanyProfilePdf.new(@link,@about_me,session[:user_logged_id])
        send_data @pdf.render, :filename => "#{@user.first_name}#{@user.last_name}CompanyTendercon.pdf", :type => "application/pdf"
      end
    end
  end

  def billing
    @user = User.find(session[:user_logged_id])
    @subscriber = UserSubscription.where(:user_id => @user.id).first

    if @subscriber.present?
      customer = Stripe::Customer.retrieve(@subscriber.stripe_id)
      if customer.present?
        customer.sources.each do |a|
          puts "a.id:#{a.last4}"
          @last_four = a.last4
          @brand = a.brand
        end
      end
    end
  end

  def get_billing
    @user = User.find(session[:user_logged_id])
    @subscriber = UserSubscription.where(:user_id => @user.id).first

    if @subscriber.present?
      customer = Stripe::Customer.retrieve(@subscriber.stripe_id)
      if customer.present?
        customer.sources.each do |a|
          puts "a.id:#{a.last4}"
          @last_four = a.last4
          @brand = a.brand
        end
      end
    end
    @data = render :partial => 'users/company/get_billing'
  end

  def credit_card_details

    @user = User.find(session[:user_logged_id])

  end

  def validate_credit_card_number
    require 'credit_card_validations/string'
    card_number = params[:card_number]
    puts "CARD:#{card_number.credit_card_brand_name}"
    card_brand = card_number.credit_card_brand_name
    detector = CreditCardValidations::Detector.new(card_number)
    puts "VALID:#{detector.valid?}"

    if detector.valid?
      render :json => { :state => 'valid',:card_brand => card_brand}
    else
      render :json => { :state => 'invalid'}
    end


  end

  def add_new_trade
    @indexes = params[:indexes]
    nums = []
    @indexes.each do |a|
      nums << a.to_i
    end
    puts nums.max
    @number = (nums.max).to_i + 1
    @trades = Trade.all
    @data = render :partial => 'users/trade'
  end

  def subscription
    @user = User.find(session[:user_logged_id])
    @user_plan = UserPlan.where(:user_id => @user.id).first

    @request_upgrade = RequestUpgrade.where(:user_id => @user.id,:status => 'pending').first
    @upgraded = RequestUpgrade.where(:user_id => @user.id,:status => 'upgraded').first

    @rejected = RequestUpgrade.where(:user_id => @user.id,:status => 'rejected').first

    if @rejected.present?
      RequestUpgrade.find(@rejected.id).destroy!
    end

    if @upgraded.present?
      RequestUpgrade.find(@upgraded.id).destroy!
    end


  end

  def get_subscription
    @user = User.find(session[:user_logged_id])
    @user_plan = UserPlan.where(:user_id => @user.id).first
    puts "@user_plan =======> #{@user_plan.inspect}"
    @request_upgrade = RequestUpgrade.where(:user_id => @user.id,:status => 'pending').first
    @upgraded = RequestUpgrade.where(:user_id => @user.id,:status => 'upgraded').first

    @rejected = RequestUpgrade.where(:user_id => @user.id,:status => 'rejected').first

    if @rejected.present?
      RequestUpgrade.find(@rejected.id).destroy!
    end

    if @upgraded.present?
      RequestUpgrade.find(@upgraded.id).destroy!
    end

    @data = render :partial => 'users/subscription/plan'
  end

  def get_company_users
    if session[:role_type] == 'Admin'
      @user = User.find(session[:user_logged_id])
      @users = User.where("id = #{@user.id} OR parent_id = #{@user.id} AND abn is not null ")
      @invited_users = User.where("parent_id = #{@user.id} AND position is null")
      #@new_invited_users = User.where("parent_id = #{@user.id} AND email_acceptance = 0 AND invited = false")
      @newly_signup_members = User.where("parent_id = #{@user.id} and registered = true")
    else
      user = User.find(session[:user_logged_id])
      puts "@user2 ===> #{user.inspect}"
      if user.parent_id.present?
        @users = User.where("id = #{user.parent_id} OR parent_id = #{user.parent_id} AND abn is not null ")
        @invited_users = User.where("parent_id = #{user.parent_id} AND position is null")
        @new_invited_users = User.where("parent_id = #{user.parent_id} AND email_acceptance = 0 AND invited = false")
        @newly_signup_members = User.where("parent_id = #{user.parent_id} and registered = true")
      else
        @users = nil
        @invited_users = nil
        @new_invited_users = nil
        @newly_signup_members = nil
      end

    end
    @user_plans =  User.where("parent_id = #{session[:user_logged_id]}")
    @user_array = []
    @user_plan_frees = []
    if @user_plans.present?
      @user_plans.each do |a|
        @user_array << a.id
      end

      if @user_array.present? && @user_array.size > 0
        @plans = UserPlan.where(:user_id =>@user_array)

        if @plans.present?
          @plans.each do |p|
            if p.plan == 'STARTER PLAN $0'
              @user_plan_frees << p.id
            end
          end
        end
        puts "@user_plan_frees:#{@user_plan_frees}"
      end
    end

    @user = User.new
    @subscription = UserSubscription.where(:user_id => session[:user_logged_id]).first
    requested_users = User.where(:parent_id => session[:user_logged_id])
    @upgraded_array = []
    if requested_users.present?
      requested_users.each do |u|
        @upgraded_array << u.id
      end

    end

    if @upgraded_array.present? && @upgraded_array.size > 0
      @upgraded_users = RequestUpgrade.where(:user_id => @upgraded_array,:status => 'upgraded')
    end

    puts "params[:upgrade]    ===========> #{params[:upgrade].inspect}"
    if params[:tab].present?
      if params[:tab] == 'upgrade'
        @upgrade = true
      elsif params[:tab] == 'deleted'
        @deleted = true
      end
    end
    puts "@upgraded_array:#{@upgraded_array}"
    puts "@@upgraded_users:#{@upgraded_users.inspect}"
    @data = render :partial => 'users/company/users'
  end

  def get_user_company
    user = User.find(params[:id])

    if user.present?
      render :json => { :company => user.company}
    else
      render :json => { :company => nil}
    end
  end

  def get_user_avatar
    avatar = Avatar.where(:user_id =>params[:id]).first

    if avatar.present?
      @avatar_name = avatar.image_file_name
      @profile_image = "http://"+request.host_with_port+"/assets/avatar/image/#{avatar.id}/original/#{@avatar_name}"
      render json: {avatar:@profile_image}
    else
      @profile_image = "https://s-media-cache-ak0.pinimg.com/236x/9a/de/a4/9adea4e40b39301576ff29f7ddebfd5b.jpg"
      render json: { avatar:@profile_image}
    end
  end

  def profile_control_tabs
    @user = User.find(session[:user_logged_id])
    if params[:tab] == 'edit_profile'
      @avatar = Avatar.new
      if params[:tab_action].present?
        @added_company_profile = CompanyProfile.where(:user_id => @user.id).first

        if @added_company_profile.present?
          @about_me = @added_company_profile.about_me
        end

        if @added_company_profile.present?
          if @added_company_profile.project_range.present?
            @p_to = @added_company_profile.project_range.split('-')
          end
        end

        @primary_trade = PrimaryTrade.where(:user_id => @user.id).first
        @secondary_trades = SecondaryTrade.where(:user_id => @user.id)
        @secondary_trade_array = []
        if @secondary_trades.present?
          @secondary_trades.each do |s|
            @secondary_trade_array << s.trade_id
          end
        end

        @trades = Trade.all

        @company_avatar = CompanyAvatar.new


        @years = []
        @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
        @to = ['','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

        for i in 1800..(Time.now.strftime('%Y').to_i) do
          @years << i
        end
        @data = render :partial => 'users/tabs/company_settings'
      else
        @positions = Position.all
        @data = render :partial => 'users/tabs/account_settings'
      end

    elsif params[:tab] == 'overview'
      if params[:tab_action].present?
        @added_company_profile = CompanyProfile.where(:user_id => @user.id).first

        if @added_company_profile.present?
          @about_me = @added_company_profile.about_me
        end

        if @added_company_profile.present?
          if @added_company_profile.project_range.present?
            @p_to = @added_company_profile.project_range.split('-')
          end
        end

        @primary_trade = PrimaryTrade.where(:user_id => @user.id).first
        @secondary_trades = SecondaryTrade.where(:user_id => @user.id)
        @secondary_trade_array = []
        if @secondary_trades.present?
          @secondary_trades.each do |s|
            @secondary_trade_array << s.trade_id
          end
        end

        @trades = Trade.all

        @company_avatar = CompanyAvatar.new


        @years = []
        @from = ['','1K','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M']
        @to = ['','10K','50K','100K','250K','500K','1M','5M','10M','20M','50M','100M','500M+']

        for i in 1800..(Time.now.strftime('%Y').to_i) do
          @years << i
        end
        @data = render :partial => 'users/tabs/company_overview'
      else
        @data = render :partial => 'users/tabs/overview'
      end

    end

  end

  def update_avatar
    @user = User.find(session[:user_logged_id])
    if @user.avatar.present?
      @user.avatar.update_attributes(:image => params[:avatar])
    else
      avatar = Avatar.new
      avatar.user_id = @user.id
      avatar.image = params[:avatar]
      avatar.save
    end

    render :json => { :state => 'valid',:url => @user.avatar.image.url(:original)}
  end

  def get_user_avatar_path
    @user = User.find(session[:user_logged_id])
    render :json => { :url => @user.avatar.image.url(:original),:state => 'valid'}
  end


  private


  def user_premitted_params
    params.require(:user).permit(:id,:first_name,:email,:password,:confirmed_password,:role,:company_attributes => [:id,:name])
  end

  def avatar_premitted_params
    params.require(:avatar).permit(:id,:user_id,:image)
  end

  def company_avatar_premitted_params
    params.require(:company_avatar).permit(:id,:user_id,:image)
  end

end