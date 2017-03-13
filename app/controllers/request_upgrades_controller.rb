class RequestUpgradesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def save_request_upgrade
    user_id = params[:user_id]
    plan = params[:plan]
    @user_plan = plan
    request_upgrade = RequestUpgrade.new
    request_upgrade.plan = plan
    request_upgrade.user_id = user_id

    @user = User.find(user_id)

    admin = User.where(:id => @user.parent_id).first

    name = "#{@user.first_name} #{@user.last_name}"

    if admin.present?
      admin_name = "#{admin.first_name} #{admin.last_name}"
      if request_upgrade.save
        if @user.request_upgrade.plan.to_i == 0
          @plan = "FREE - Starter Plan"
        elsif @user.user_plan.plan.to_i == 1
          @plan = "Professional Plan - monthly"
        else
          @plan = "Professional Plan - 12 months"
        end



        if @user.role_type != 'Admin'
          notification = Notification.new
          notification.description = "#{admin.first_name} #{admin.last_name} requested to upgrade his plan"
          notification.user_id = admin.id
          notification.save

          email_notification = EmailNotification.new
          email_notification.user_id = admin.id
          email_notification.description = "#{@user.first_name} #{@user.last_name} requested to upgrade his plan"
          email_notification.save
          TenderconMailer.delay.sent_request_upgrade(admin.email,name,@plan,admin_name)
        end

        render :json => { :state => 'valid',:plan => @user_plan}
      end
    else
      puts  "sadjh ========> #{user_id}"
      puts  "sadjh ========> #{params[:plan]}"
      if params[:plan].to_i == 0
        @plan = "FREE - Starter Plan"
      elsif params[:plan].to_i == 1
        @plan = "Professional Plan - monthly"
      else
        @plan = "Professional Plan - 12 months"
      end
      if params[:plan].to_i == 1
        @amount = 66.00
      else
        @amount = 49.50
      end

      user_subscription = UserSubscription.where(:user_id => @user.id).first

      if user_subscription.present?


        if @user_plan.to_i == 1
          stripe_plan = 1002
        elsif  @user_plan.to_i == 2
          stripe_plan = 1001
        end

        customer = Stripe::Customer.retrieve(user_subscription.stripe_id)
        puts "customer.inspect =======> #{ customer.subscriptions.first.inspect}"

        customer.sources.each do |a|
          puts "a.id:#{a.id}"

          @id =  a.id
        end
        @user_plan = 0
        subscription = Stripe::Subscription.retrieve(user_subscription.customer_subscription_id)
        subscription.plan = stripe_plan
        subscription.save



        # puts customer.inspect
        # customer.sources.each do |a|
        #   puts "a.id:#{a.id}"
        #
        #   @id =  a.id
        # end
        # puts "ID:#{@id}"
        # card = customer.sources.retrieve(@id)
        # card.delete
        #
        # cu = Stripe::Customer.retrieve(user_subscription.stripe_id)
        # cu.card = params[:stripeToken]
        # cu.save
        # cu.sources.each do |c|
        #   @month = c.exp_month.inspect
        #   @year =  c.exp_year.inspect
        # end

      end


      UserPlan.where(:user_id => user_id).update_all(:plan => params[:plan].to_i, :amount => @amount)
      #request_upgrade = RequestUpgrade.new
      #request_upgrade.plan = plan
      #request_upgrade.user_id = user_id
      #request_upgrade.save
      render :json => { :state => 'valid',:plan => @user_plan}
    end

  end

end