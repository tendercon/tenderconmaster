class InvitesController < ApplicationController
  layout 'users_layout', :on => [:registration]
  layout 'application', :on => [:index]
  before_filter :is_logged?,  :except => [:registration,:update_invited_user,:update,:user,:save_invited_user]
  skip_before_action :verify_authenticity_token

  def index

    if session[:role_type] == 'Admin'
      Rails.logger.info "session[:user_logged_id]:#{session[:user_logged_id]}"
      puts "session[:user_logged_id]:#{session[:user_logged_id]}"
      @user = User.find(session[:user_logged_id])
      @users = User.where("id = #{@user.id} OR parent_id = #{@user.id} AND abn is not null ")
      @invited_users = User.where("parent_id = #{@user.id} AND position is null")
      #@new_invited_users = User.where("parent_id = #{@user.id} AND email_acceptance = 0 AND invited = false")
      @newly_signup_members = User.where("parent_id = #{@user.id} and registered = true")
    else

      user = User.find(session[:user_logged_id])
      @users = User.where("id = #{user.parent_id} OR parent_id = #{user.parent_id} AND abn is not null ")
      @invited_users = User.where("parent_id = #{user.parent_id} AND position is null")
      @new_invited_users = User.where("parent_id = #{user.parent_id} AND email_acceptance = 0 AND invited = false")
      @newly_signup_members = User.where("parent_id = #{user.parent_id} and registered = true")
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


    puts "@upgraded_array:#{@upgraded_array}"
    puts "@@upgraded_users:#{@upgraded_users.inspect}"

  end

  def new
    @user = User.new
  end

  def sent_invite
    @user = User.new
    @parent = User.find(session[:user_logged_id])
    @user.first_name = params[:f_name]
    @user.name = "#{params[:f_name]} #{params[:l_name]}"
    @user.last_name = params[:l_name]
    @user.email = params[:email]
    @plan_package = params[:plan_package]
    if @parent.role == 'Head Contractor'
      @user.role = @parent.role
    elsif @parent.role == 'Sub Contractor'
      @user.role = @parent.role
    end

    @user.role_type = 'Team Member'

    @user.parent_id = @parent.id
    @user.invited = false
    @user.verified = true
    @user.password = 'Admin1234'
    @user.confirmed_password = 'Admin1234'
    if @user.save
      User.where(:id => @user.id).update_all(:password => nil,:confirmed_password => nil)
      user_plan = UserPlan.new
      user_plan.user_id = @user.id
      puts "params[:plan]:#{params[:plan]}"
      puts "params[:plan]:#{params[:plan].present?}"
      puts "@plan_package:#{@plan_package}"
      puts "@plan_package:#{@plan_package.present?}"
      if params[:plan] == 'STARTER PLAN $0'
        user_plan.plan = 0
      else
        if @plan_package.present?
          if @plan_package.to_i == 1
            user_plan.plan = 1
          else
            user_plan.plan =  2
          end
        else
          user_plan.plan = 0
        end
      end

      if @plan_package.present?
        if @plan_package.to_i == 2
          user_plan.amount = 49.50
        else
          user_plan.amount = 66.00
        end
      else
        user_plan.amount = 0.00
      end
      user_plan.save

      session[:key] = nil
      session[:n_email] = nil
      session[:nf_name] = nil
      session[:nl_name] = nil
      session[:n_plan] = nil

      admin = User.find(session[:user_logged_id])
      admin_name = "#{admin.first_name} #{admin.last_name}"
      invited_name = "#{@user.first_name} #{@user.last_name}"
      email_notification = EmailNotification.new
      email_notification.user_id = @user.id
      email_notification.description = 'Invitation request to join the team.'
      email_notification.save

      notification = Notification.new
      notification.description = "You invited #{@user.first_name} #{@user.last_name} to your team."
      notification.user_id = @user.parent_id
      notification.save

      TenderconMailer.delay.sent_invitation_email(@user.email,admin_name,invited_name,request.host_with_port,admin.company,@user.id)
      render :json => { :state => 'valid'}
    end
  end

  def update_plan
    id = params[:user_id]
    plan = params[:plan]

    if plan.to_i == 1
      @amount = 66.00
    elsif plan.to_i == 2
      @amount = 594.00
    end


    @user = User.find(id)

    admin = User.find(@user.parent_id)

    [@user.id,admin.id].each_with_index do |a,index|
      notification = Notification.new
      if index > 0
        notification.description = "You approved the request of #{@user.first_name} #{@user.last_name} to upgrade his Tendercon Plan"
      else
        notification.description = "Your request to upgrade Plan approved by company admin."
      end

      notification.user_id = a
      notification.save
    end

    name = "#{@user.first_name} #{@user.last_name}"
    email_notification = EmailNotification.new
    email_notification.user_id = @user.id
    email_notification.description = "Your request to upgrade Plan approved by company admin."
    email_notification.save

    TenderconMailer.delay.approved_request_email_notification(@user.email,name,'member')
    UserPlan.where(:user_id => id).update_all(:plan => plan, :amount => @amount)
    RequestUpgrade.where(:user_id => id).update_all(:status => 'upgraded')

    # if plan.to_i == 2
    #   token = params[:stripeToken]
    #   customer = Stripe::Customer.create(
    #       card: token,
    #       plan: 1001,
    #       email: @user.email
    #   )
    # end


    render :json => { :state => 'valid'}
  end


  def admin_update_plan
    id = params[:user_id]
    plan = params[:plan]

    if plan.to_i == 1
      @amount = 66.00
    elsif plan.to_i == 2
      @amount = 594.00
    end

    RequestUpgrade.where(:user_id => id).destroy_all

    request = RequestUpgrade.new
    request.plan = plan
    request.status = 'upgraded'
    request.user_id = id
    request.save

    @user = User.find(id)

    admin = User.find(@user.parent_id)

    [@user.id,admin.id].each_with_index do |a,index|
      notification = Notification.new
      if index > 0
        notification.description = "You upgrade the Plan of #{@user.first_name} #{@user.last_name}"
      else
        notification.description = "Your plan was upgraded by company admin."
      end

      notification.user_id = a
      notification.save
    end

    name = "#{@user.first_name} #{@user.last_name}"
    email_notification = EmailNotification.new
    email_notification.user_id = @user.id
    email_notification.description = "Your request to upgrade Plan approved by company admin."
    email_notification.save

    TenderconMailer.delay.approved_request_email_notification(@user.email,name,'admin')


    UserPlan.where(:user_id => id).update_all(:plan => plan, :amount => @amount)

    # if plan.to_i == 2
    #   user_subscription = UserSubscription.where(:user_id => @user.id).first
    #   customer.sources.each do |a|
    #     puts "a.id:#{a.id}"
    #
    #     @id =  a.id
    #   end
    #   token = params[:stripeToken]
    #   customer = Stripe::Customer.create(
    #       card: token,
    #       plan: 1001,
    #       email: @user.email
    #   )
    # end

    render :json => { :state => 'valid'}
  end

  def rejected_request
    id = params[:user_id]
    plan = params[:plan]


    @user = User.find(id)

    admin = User.find(@user.parent_id)

    [@user.id,admin.id].each_with_index do |a,index|
      notification = Notification.new
      if index > 0
        notification.description = "You rejected the request of #{@user.first_name} #{@user.last_name} to upgrade his Tendercon Plan"
      else
        notification.description = "Your request to upgrade Plan was rejected by company admin."
      end

      notification.user_id = a
      notification.save
    end

    name = "#{@user.first_name} #{@user.last_name}"
    email_notification = EmailNotification.new
    email_notification.user_id = @user.id
    email_notification.description = "Your request to upgrade Plan was rejected by company admin."
    email_notification.save

    TenderconMailer.delay.rejected_request_email_notification(@user.email,name)
    RequestUpgrade.where(:user_id => id).update_all(:status => 'rejected')
    render :json => { :state => 'valid'}
  end

  def success

  end

  def registration
    @user = User.find(params[:id])
    User.where(:id => @user.id).update_all(:email_acceptance => true)
    @parent = User.find(@user.parent_id)
  end

  def update_invited_user

  end

  def update
    @user_id =  params[:user_id]
    @user = User.find(@user_id)

    if User.where(:id => @user_id).update_all(
        :email => params[:user][:email],
        :name => params[:user][:name],
        :company => params[:company],
        :password => (User.rehash_password params[:user][:password]),
        :confirmed_password => (User.rehash_password params[:user][:confirmed_password])
       )
      notification = Notification.new
      notification.description = "#{@user.first_name} #{@user.last_name} has joined to your team."
      notification.user_id = @user.parent_id
      notification.save

      email_notification = EmailNotification.new
      email_notification.user_id = @user.parent_id
      email_notification.description = "#{@user.first_name} #{@user.last_name} has joined to your team."
      email_notification.save

      @parent = User.find(@user.parent_id)
      admin_name = "#{@parent.first_name} #{@parent.last_name}"
      user_name = "#{@user.first_name} #{@user.last_name}"

      TenderconMailer.delay.email_notification_member_joined(@parent.email,user_name,admin_name)

      redirect_to authenticate_users_path(:email => @user.email,:invites => true)
    end
  end

  def add_user_position
    position  = params[:postion]
    id = params[:id]
    new_position = params[:new_position]
    f_name = params[:f_name]
    l_name = params[:l_name]

    @user = User.find(id)
    @parent = User.find(@user.parent_id)


    if position.to_i > 0
      @position = position
    else
      n_position = Position.new
      n_position.title = new_position
      n_position.save

      @position = n_position
    end


    if User.where(:id => @user.id).update_all(
           :first_name => f_name,
           :last_name => l_name,
           :position => @position,
           :company => @parent.company,
           :abn => @parent.abn,
           :tendercon_id => @parent.tendercon_id,
           :trade_name => @parent.trade_name,
           :registered => true
        )

        companies = Company.where(:user_id => @parent.id)

        if companies.present?
          companies.each do |c|
            company = Company.new
            company.name = c.name
            company.user_id = @user.id
            company.save
          end
        end


        address = Address.new
        address.state = @parent.address.state
        address.location = @parent.address.location
        address.postcode = @parent.address.postcode
        address.suburb = @parent.address.suburb
        address.timezone = @parent.address.timezone
        address.user_id = @user.id
        address.save

        primary_trades = PrimaryTrade.where(:user_id => @parent.id)

        if primary_trades.present?
          primary_trades.each do |p|
            primary = PrimaryTrade.new
            primary.trade_id = p.trade_id
            primary.user_id = @user.id
            primary.save
          end
        end

        secondary_trades = SecondaryTrade.where(:user_id => @parent.id)

        if secondary_trades.present?
          secondary_trades.each do |s|
            secondary = SecondaryTrade.new
            secondary.trade_id = s.trade_id
            secondary.user_id = @user.id
            secondary.save
          end
        end
    end


    render :json => { :state => 'valid'}

  end

  def re_invite_user
    @user = User.find(params[:id])
    admin = User.find(session[:user_logged_id])
    admin_name = "#{admin.first_name} #{admin.last_name}"
    invited_name = "#{@user.first_name} #{@user.last_name}"
    TenderconMailer.delay.sent_invitation_email(@user.email,admin_name,invited_name,request.host_with_port,admin.company,@user.id)
    redirect_to success_invites_path(:reinvite => true)
  end

  def delete_team_members

    user = User.find(params[:id])

    if user.destroy
      Address.where(:user_id => user.id).destroy_all
      PrimaryTrade.where(:user_id => user.id).destroy_all
      SecondaryTrade.where(:user_id => user.id).destroy_all
      Avatar.where(:user_id => user.id).destroy_all
      Company.where(:user_id => user.id).destroy_all
      CompanyAvatar.where(:user_id => user.id).destroy_all
      ProjectAddress.where(:user_id => user.id).destroy_all
      CompanyProfile.where(:user_id => user.id).destroy_all
      ProjectPortfolio.where(:user_id => user.id).destroy_all
      ProjectAvatar.where(:user_id => user.id).destroy_all
      ProjectTrade.where(:user_id => user.id).destroy_all
      UserFacebook.where(:user_id => user.id).destroy_all
      UserInfo.where(:user_id => user.id).destroy_all
      UserPlan.where(:user_id => user.id).destroy_all
      UserSubscription.where(:user_id => user.id).destroy_all
      Notification.where(:user_id => user.id).destroy_all
      EmailNotification.where(:user_id => user.id).destroy_all
      RequestUpgrade.where(:user_id => user.id).destroy_all
      flash[:notice] = 'Team Member successfully deleted.'

      redirect_to invites_path

    end
  end

  def user
    @user = User.new

  end

  def save_invited_user
    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]
    @user.parent_id = params[:parent_id]
    @user.role = 'Sub Contractor'
    @user.role_type = 'Team Member'
    @user.password = params[:password]
    @user.confirmed_password = params[:confirmed_password]


    if @user.save
      tender_id = params[:tender_id]

      user_tender = UserTender.new
      user_tender.user_id = @user.id
      user_tender.tender_id = tender_id
      user_tender.save

      redirect_to authenticate_users_path(:email => @user.email,:invites => true)
    else
      render :user
    end
  end

  def decline_tender_invite
    tender_id = params[:tender_id]
    trade_id = params[:trade]
    email = params[:email]

    invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => email).update_all(:status => 'declined',:tender_declined_date => Time.now,:tender_open_date => Time.now)

    redirect_to login_users_path
  end

  def decline_trade_invite
    tender_id = params[:tender_id]
    trade_id = params[:trade]
    user = User.find(params[:id])

    invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => user.email).update_all(:status => 'declined')

    render :json => { :state => 'valid'}
  end

  def check_trade_status
    @tender_id = params[:tender_id]
    @tender = Tender.find(@tender_id)
    trade_ids = params[:ids]
    user = User.find(params[:sc_id])

    invites = TenderInvite.where("tender_id = #{@tender.id} and email = '#{user.email}' and (status is null OR status = 'opened')")
    invite_trades = TenderInvite.where("tender_id = #{@tender.id} and email = '#{user.email}' and (status is null OR status = 'opened' OR status='accepted')")
    if invites.present?
      trade_array = []
      invite_trades.each do |a|
        trade_array << a.trade_id
      end
      render :json => { :state => 'invalid',:trades => trade_array}
    else
      trade_array = []
      invite_trades.each do |a|
        trade_array << a.trade_id
      end
      render :json => { :state => 'valid',:trades => trade_array}
    end

  end

  def update_tender_invite
    @tender_id = params[:tender_id]
    trade_id = params[:trade_id]
    user = User.find(params[:sc_id])
    txt = params[:txt]
    @tender = Tender.find(@tender_id)
    if txt == 'Accept'
      tender_request_quote = TenderRequestQuote.new
      tender_request_quote.tender_id = @tender_id
      tender_request_quote.sc_id = user.id
      tender_request_quote.hc_id = @tender.user_id
      tender_request_quote.save

      tender_request_trade = TenderRequestTrade.new
      tender_request_trade.tender_request_quote_id = tender_request_quote.id
      tender_request_trade.trade_id = trade_id
      tender_request_trade.save
      @notification = 'Trade successfully accepted.'
      TenderInvite.where(:tender_id => @tender.id,:email => user.email,:trade_id => trade_id).update_all(:status => 'accepted',:tender_acceptance_date => Time.now,:tender_declined_date => nil)
    elsif txt == 'Decline'
      @notification = 'Trade declined.'
      TenderInvite.where(:tender_id => @tender.id,:email => user.email,:trade_id => trade_id).update_all(:status => 'rejected',:tender_declined_date => Time.now,:tender_acceptance_date => nil)
    end

    if txt != 'None'
      @trade_categories = TradeCategory.all
      @invite_count = TenderInvite.where(:tender_id => @tender.id,:email => user.email,:status => nil).count()
      @data = render :partial => 'invites/invited_tender_trades'
    end
  end

end