module InvitesHelper

  def update_user_registered id
    if id.present?
      if id.to_i > 0
        User.where(:id => id).update_all(
              :shown => true
        )
      end
    end
  end

  def check_user_created_status id
    @bool = false
    if id.present?
      if id.to_i > 0
        user = User.find(id)

        if user.present?
          created = user.created_at
          now = Time.now
          puts "Now:#{now}"

          if now >= (created + 2.days)
            @bool =  true
          else
            @bool = false
          end
        end
      end
      @bool
    end
  end

  def check_tender_trade_status trade_id,tender_id,email
    puts "sdjahsjdhasjdsa--------->#{trade_id}"
    tender_invite = TenderInvite.where(:tender_id => tender_id,:trade_id => trade_id,:email => email).first
    puts "sadksajdksajdksajdklajds:#{tender_invite.inspect}"
    if tender_invite.present?
      tender_invite.status
    else
      nil
    end
  end

  def get_user_plan id
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

  def get_user_plan_value id
    subscription = UserPlan.where(:user_id => id).first

    if subscription.present?
      subscription.plan
    else
      nil
    end

  end


  def check_if_have_pending_request id

    request = RequestUpgrade.where(:user_id => id).first

    if request.present?
      if request.status == 'pending'
        true
      else
        false
      end
    end
  end

  def compute_cost id

    if id.to_i > 0
      subscription = RequestUpgrade.where(:user_id => id).first

      if subscription.present?

        if subscription.plan.to_i == 1
          66.00
        elsif subscription.plan.to_i == 2
          594.00
        else
          0.00
        end
      end
    else
      nil
    end

  end

  def return_user_name id

    if id.to_i > 0
      user = User.find(id)

      if user.present?
        "#{user.first_name} #{user.last_name}"
      end
    end

  end


end