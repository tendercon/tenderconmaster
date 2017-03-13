class SubscribersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new

  end

  def update
    @user = User.find(session[:user_logged_id])
    user_subscription = UserSubscription.where(:user_id => @user.id).first
    user_plan = params[:user_plan]
    if user_subscription.present?
      customer = Stripe::Customer.retrieve(user_subscription.stripe_id)
      puts customer.inspect
      customer.sources.each do |a|
        puts "a.id:#{a.id}"

        @id =  a.id
      end
      puts "ID:#{@id}"
      card = customer.sources.retrieve(@id)
      card.delete

      cu = Stripe::Customer.retrieve(user_subscription.stripe_id)
      cu.card = params[:stripeToken]
      cu.save
      cu.sources.each do |c|
        @month = c.exp_month.inspect
        @year =  c.exp_year.inspect
      end
      UserSubscription.where(:user_id => @user.id).update_all(:expiry_date => Date.new(@year.to_i,@month.to_i),
                        :notify1 => false, :notify2 => false,:lightbox1 => false,:lightbox2 => false,:lightbox3 => false,
                        :lightbox4 => false)

      session[:email2] = nil
    else
      token = params[:stripeToken]
      if user_plan.to_i == 1
        stripe_plan = 1002
      elsif  user_plan.to_i == 2
        stripe_plan = 1001
      else
        stripe_plan = 1003
      end

      customer = Stripe::Customer.create(
         card: token,
         plan: stripe_plan,
         email: @user.email
      )



      customer.sources.each do |c|
        @month = c.exp_month.inspect
        @year =  c.exp_year.inspect
      end


      subscription_id = customer.subscriptions.first.id
      puts "subscription_id ===========> #{subscription_id}"
      @subscriber = UserSubscription.new
      @subscriber.user_id = @user.id
      @subscriber.action_type = params[:action_type].present? ? params[:action_type]: nil
      @subscriber.card_number = nil
      @subscriber.subscribed = true
      @subscriber.customer_subscription_id = subscription_id
      @subscriber.stripe_id = customer.id
      @subscriber.expiry_date = Date.new(@year.to_i,@month.to_i)
      @subscriber.save

    end

    session[:n_email] = params[:n_email]
    session[:nf_name] = params[:f_name]
    session[:nl_name] = params[:l_name]
    session[:n_plan] = params[:n_plan]

    if params[:new_credit_card].present?

      redirect_to invites_path(:fname => params[:f_name],:lname => params[:lname],:email => params[:n_email],:plan => params[:n_plan],:member => 1)

    elsif params[:request_user].present?
      redirect_to invites_path(:user_requested => params[:request_user])

    elsif params[:admin_upgrade].present?
      redirect_to invites_path(:upgrade => true, :id =>params[:admin_upgrade])
    elsif params[:no_credit_card].present?
      redirect_to "/users/profile?id=#{@user.id}&subscription=true"
    elsif user_plan.present?
      redirect_to "/users/profile?id=#{@user.id}&subscription=true"
    else
      redirect_to billing_users_path
    end


  end

  def update_lighbox
    id = params[:id]
    @user = User.find(id)

    if params[:ligthbox].present?
      if UserSubscription.where(:user_id => id).update_all(:lightbox2 => 1)
        render :json => { :state => 'valid'}
      end
    elsif params[:ligthbox2].present?
      if UserSubscription.where(:user_id => id).update_all(:lightbox3 => 1)
        render :json => { :state => 'valid'}
      end
    elsif params[:ligthbox3].present?
      if UserSubscription.where(:user_id => id).update_all(:lightbox4 => 1)
        render :json => { :state => 'valid'}
      end
    elsif params[:notify1].present?
      if UserSubscription.where(:user_id => id).update_all(:notify1 => 1)
        render :json => { :state => 'valid'}
      end
    elsif params[:notify2].present?
      if UserSubscription.where(:user_id => id).update_all(:notify2 => 1)
        render :json => { :state => 'valid'}
      end
    else
      if UserSubscription.where(:user_id => id).update_all(:lightbox1 => 1)
        if !session[:email2].present?
          path = "http://"+request.host_with_port+"/users/authenticate?email=#{@user.email}&credit_card=true"
          TenderconMailer.credit_card_will_expire_email2(@user.email,@user.id,path,@diff.to_i).deliver_now
        end
        session[:email2] = true
        render :json => { :state => 'valid'}
      else
        render :json => { :state => 'invalid'}
      end
    end



  end
end