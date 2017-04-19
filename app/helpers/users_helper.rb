module UsersHelper

  def get_postion id

    if id.to_i > 0
      position = Position.find(id)

      if position.present?
        position.title
      else
        nil
      end
    else
      nil
    end
  end

  def get_suburb company_id
    company = Company.find(company_id)
    if company.present?
      address = Address.where(:user_id => company.user_id).first

      if address.present?
        @suburb = address.suburb
      end
    end
    @suburb
  end

  def get_state company_id
    company = Company.find(company_id)
    if company.present?
      address = Address.where(:user_id => company.user_id).first

      if address.present?
        @suburb = address.state
      end
    end
    @suburb
  end

  def return_name email

    user = User.where(:email => email).first

    if user.present?
      user.name
    else
      nil
    end
  end

  def get_id_by_email email
    user = User.where(:email => email).first

    if user.present?
      user.id
    else
      nil
    end
  end

  def return_hc_name user_id
    user = User.where(:id => user_id).first

    if user.present?
      "#{user.first_name} #{user.last_name}"
    else
      nil
    end
  end

  def return_trade trade_id
    trade = Trade.find(trade_id)
    Rails.logger.info "trade =====> #{trade.inspect}"
    if trade.present?
      if trade.name.present?
        trade.name
      else
        nil
      end

    else
      nil
    end

  end

  def user_plan id
    if id.to_i > 0
      subscription = UserPlan.where(:user_id => id).first

      if subscription.present?

        if subscription.plan.to_i == 1
          "Professional Plan - monthly"
        elsif subscription.plan.to_i == 2
          "Professional Plan - 12 months"
        else
          "FREE - Starter Plan"
        end
      end
    else
      nil
    end
  end

  def user_subscription_amount id
    if id.to_i > 0
      subscription = RequestUpgrade.where(:user_id => id).first

      if subscription.present?
        if subscription.plan.to_i == 2
          44.50
        elsif subscription.plan.to_i == 1
          66.00
        end

      end
    else
      nil
    end
  end

  def get_user_company_name id

    user  = User.find(id)
    user.company
  end

  def get_user_trade_name id

    user = User.where(:id => id).first
    if user.present?
      if user.trade_name.present?
        user.trade_name
      else
        user.email
      end
    else
      nil
    end
  end

  def get_user_created id

    user  = User.find(id)
    user.created_at.strftime("%d-%m-%Y %H:%M %p")
  end

  def get_user_name id
    user = User.find(id)

    if user.present?
      "#{user.first_name} #{user.last_name}"
    end
  end

  def get_user_avatar id

    avatar = Avatar.where(:user_id => id ).first
    puts "avatar:#{avatar.inspect}"
    if avatar.present?
      @avatar_name = avatar.image_file_name
      @profile_image = "http://"+request.host_with_port+"/assets/avatar/image/#{avatar.id}/original/#{@avatar_name}"
    else
      @profile_image = "https://s-media-cache-ak0.pinimg.com/236x/9a/de/a4/9adea4e40b39301576ff29f7ddebfd5b.jpg"
    end

  end

  def get_user_company_avatar user_id
    company_avatar = CompanyAvatar.where(:user_id => user_id).first

    if company_avatar.present?
      @profile_image = "http://"+request.host_with_port+"/assets/company_avatar/image/#{company_avatar.id}/original/#{company_avatar.image_file_name}"
    end

  end

  def get_user_logged_status id

    user = User.find(id)

    if user.present?
      user.logged_status
    else
      nil
    end
  end

  def get_comment_document_path comment_id
    puts  "------------------------>get_comment_document_path"
    comment = RfiComment.find(comment_id)

    if comment.present?
      rfi = Rfi.find(comment.rfi_id)
      "http://"+request.host_with_port+"/assets/comments/#{rfi.ref_no}-#{comment.id}/#{rfi.ref_no}-Supporting Files.zip"
    end
  end

  def get_document_path_name comment_id
    comment = RfiComment.find(comment_id)

    if comment.present?
      rfi = Rfi.find(comment.rfi_id)
      "#{rfi.ref_no}-Supporting Files.zip"
    else
      nil
    end
  end

  def check_if_have_docs? comment_id
    comment = RfiComment.find(comment_id)

    if comment.present?
      rfi = Rfi.find(comment.rfi_id)

      if File.directory? "#{Rails.root}/public/assets/comments/#{rfi.ref_no}-#{comment.id}"
        true
      else
        false
      end
    else
      false
    end

  end

  def check_if_user_exists email
    user = User.where(:email => email).last

    if user.present?
      true
    else
      false
    end
  end




end
