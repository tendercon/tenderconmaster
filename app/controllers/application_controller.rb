class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :is_logged?, :add_to_open_tender,  :except => [:login,:authenticate,:register,:create_user,
                                                                  :forgot_password,:reset_password,:user_company_exist,
                                                                  :account_taken,:registration_completed,:resent_email_notification,
                                                                  :validate_user_email,:email_authentication,:validation_complete,:update_password,
                                                                  :password_changed,:validate_account,:token_expired,:generate_new_token,:gettoken]
  before_filter :notify, :except => [:logout,:login,:register,:create_user]
  before_filter :add_to_open_tender, :only => [:open_tender]


  def is_logged?
    if session[:time_logged].present?
      if session[:time_logged] <= Time.now
        session[:time_logged] = nil
        flash[:error] = "Session is expired. Please login again"
        redirect_to login_users_path
      end
    else
      flash[:error] = "Please login first"
      redirect_to login_users_path
    end
  end

  def add_to_open_tender
    sub_contractors = User.where(:role => 'Sub Contractor')
    user_ids = []
    if sub_contractors.present?
      sub_contractors.each do |u|
        user_ids << u.id
      end
    end

    if user_ids.present?
      OpenTender.add_new_subcontractors(user_ids)
    end
  end

  def notify

    if session[:user_logged_id].present?
      UserSubscription.delay.notify(session[:user_logged_id],request.host_with_port)

      @user = User.find(session[:user_logged_id])
      if @user.present?
        @user_name = "#{@user.first_name} #{@user.last_name}"
        @subs = UserSubscription.where(:user_id => @user.id).first
        @plan = UserPlan.where(:user_id => @user.id).first
        @email_notifs = EmailNotification.where(:user_id => @user.id)
        @email_count = EmailNotification.where(:user_id => @user.id).count()
        @user_cnt = User.where(:parent_id => @user.id).count()
        @project_count =  ProjectPortfolio.where(:user_id => @user.id).count()
        @tenders = Tender.where(:user_id => @user.id,:publish => true)
        @notifs = Notification.where(:user_id => @user.id)
        @notif_count = Notification.where(:user_id => @user.id).count()
        @rfis = Rfi.where(:hc_id => session[:user_logged_id])
        @rfi_count = Rfi.where(:hc_id => session[:user_logged_id]).count()
        @sc_rfis = Rfi.where(:user_id => session[:user_logged_id])
        @sc_rfi_count = Rfi.where(:user_id => session[:user_logged_id]).count()
        @sc_rfi_shareds = SharedRfi.where(:user_id => session[:user_logged_id])
        @sc_rfi_shared_count = SharedRfi.where(:user_id => session[:user_logged_id]).count
        @open_tenders = OpenTender.where(:user_id => session[:user_logged_id])

        tender_arr = []
        if @open_tenders.present?
          @open_tenders.each do |a|
            invite = TenderInvite.where(:tender_id => a.tender_id, :user_id => session[:user_logged_id]).first
            if invite.present?
              OpenTender.where(:tender_id => a.tender_id,:user_id => session[:user_logged_id]).delete_all()
            else
              tender_arr << a.tender_id
            end
          end
        end

        if tender_arr.present?
          @open_tender_size = Tender.where(:id => tender_arr.uniq,:publish => true).count()
        else
          @open_tender_size = 0
        end



        @tender_invites = TenderInvite.where(:user_id => session[:user_logged_id])
        @rfis_array = []
        @sc_invite_notifs =  ScInviteNotification.where(:user_id => session[:user_logged_id],:seen => 0)
        @sc_invite_notif_count =  ScInviteNotification.where(:user_id => session[:user_logged_id],:seen => 0).count()
        if session[:role] == 'Head Contractor'
          @quote_array = []
          @quote_notifs = QuoteNotification.where(:hc_id => session[:user_logged_id])
          @quote_notif_count = QuoteNotification.where(:hc_id => session[:user_logged_id]).count()
        end

        if session[:role] == 'Head Contractor'
          @notification_count = @notif_count + @rfi_count + @quote_notif_count
        elsif session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
          @notification_count = @notif_count + @sc_rfi_count + @sc_rfi_shared_count + @sc_invite_notif_count
        end

        shared = []
        if @sc_rfi_shareds.present?
          @sc_rfi_shareds.each do |a|
            shared << a.rfi_id
          end
        end

        if shared.present?
          @sc_rfi_shared = SharedRfi.where(:rfi_id => shared.uniq)
        else
          @sc_rfi_shared = nil
        end



        if  @email_count.to_i > 0
          @email_notif_count = @email_count
        else
          @email_notif_count = nil
        end

        if  @notif_count.to_i > 0
          @notifs_count = @notif_count
        else
          @notifs_count = nil
        end

        if @user.avatar.present?
          #@user.avatars.each do |a|
          #  @id = a.id
          #  @avatar_name = a.image_file_name
          #  @profile_image = "http://"+request.host_with_port+"/assets/avatar/image/#{@id}/original/#{@avatar_name}"
          #end
        end

        if @subs.present?
          if @subs.expiry_date.present?
            @diff = @subs.expiry_date - Date.today
            puts "TODAY:#{@diff.to_i}"

            if @diff == 1
              @expired = @subs.expiry_date.to_datetime.strftime('%Y/%m/%d')
            end

          end

        end
      end
    end

  end


end
