class TenderconMailer < ActionMailer::Base
  default from: 'constructionclubau@gmail.com'
  #include SendGrid
  def reset_password(email,root_path,user_id)

     puts "email:#{email}"
     puts "root_path:#{root_path}"
     @root_path = 'http://'#root_path
     @user_id = #user_id
     @email = email
     @messages = 'You have requested to reset your password'
     mail(to: @email, subject: 'Reset Password')


    #mail :from => 'info@tendercon.com',to: 'ryanhe@tendercon.com', subject: 'Reset Password'
    # mg_client = Mailgun::Client.new 'key-621e0d6db490426eb845dbcb992bda2c'
    # message_params = {:from    => 'joe_dhay@yahoo.co,',
    #                   :to      => 'agile.jjp@gmail.com',
    #                   :subject => 'Sample Mail using Mailgun API',
    #                   :text    => 'This mail is sent using Mailgun API via mailgun-ruby'}
    # mg_client.send_message 'tendercon.com', message_params

  end

  def reset_password_confirmation(email,user_id)
    @user_id = user_id
    @email = email
    mail(to: @email, subject: 'Reset Password')
  end

  def sent_sc_invites email,name,trade,path,decline_path
    puts "decline_path -----------> #{decline_path.inspect}"
    @name = name
    @email = email
    @path = path
    @decline_path = decline_path
    @messages = "You are invited by HEAD Contractor to quote on #{trade} project"
    mail(to: @email, subject: 'Invited SC')
  end

  def registration_email email,root_path,user_id,unique_key
    @root_path = root_path
    @user_id = user_id
    @email = email
    @unique_key = unique_key
    @messages = 'You are successfully registered to Tendercon'
    mail(to: @email, subject: 'Registration Completed')
  end

  def user_request_to_admin email,user_id,first,second,third,availability,contact_number
    @user_id = user_id
    @email = email
    @first = first
    @second = second
    @third = third
    @availability = availability
    @contact = contact_number
    @messages = "User #{email} is requesting for activation of account for attempting to input 3 times invalid ABN."
    mail(to: 'agile.jjp@gmail.com', subject: 'Request user activation')
  end

  def user_request_to_admin_copy email,user_id,first,second,third,availability,contact_number
    @user_id = user_id
    @email = email
    @first = first
    @second = second
    @third = third
    @availability = availability
    @contact = contact_number
    @messages = "You have requested for Tendercon Admin to reactivate your account for inserting 3 invalid ABN."
    mail(to: email, subject: 'Request account activation')
  end

  def sent_new_position_email_to_admin email,user_id,position
    @user_id = user_id
    @email = email
    @position = position
    @messages = "#{email}, created new position"
    mail(to: 'agile.jjp@gmail.com', subject: 'New position created')
  end

  def sent_new_trade_email_to_admin email,user_id,trade
    @user_id = user_id
    @email = email
    @trade = trade
    @messages = "#{email}, created new trade"
    mail(to: 'agile.jjp@gmail.com', subject: 'New trade created')
  end

  def welcome_email email,user_id
    @user_id = user_id
    @email = email
    @messages = "Welcome to Tendercon! Thanks so much for joining us. Happy tendering."
    mail(to: email, subject: 'Welcome to Tendercon')
  end

  def delete_email email,user_id
    @user_id = user_id
    @email = email
    @messages = "Your Tendercon account has been deleted."
    mail(to: email, subject: 'Tendercon account deleted.')
  end

  def credit_card_will_expire email,user_id,path
    @user_id = user_id
    @email = email
    @path = path
    mail(to: email, subject: 'Credit Card is about to expire')

  end

  def credit_card_will_expire_email2 email,user_id,path,days
    @user_id = user_id
    @email = email
    @path = path
    @days = days
    mail(to: email, subject: "Your Company Credit Card will expire in #{@days} days")

  end

  def sent_invitation_email email,admin_name,user_invited_name,path,company_name,user_id
    @user_id = user_id
    @email = email
    @path = path
    @first_name = user_invited_name
    @messages = "#{admin_name} has invited you to be part of #{company_name}. "
    @root_path = path
    mail(to: email, subject: "you've been invited by #{admin_name} to join Tendercon")
  end

  def sent_request_upgrade email,user_name,plan,admin_name
    @email = email
    @first_name = admin_name
    @messages = "Your team member #{user_name} requested to upgrade his plan to #{plan}"
    mail(to: email, subject: "Request upgrade plan")

  end

  def email_notification_member_joined  email,user_name,admin_name
    @email = email
    @first_name = admin_name
    @messages = "#{user_name} has joined to your team."
    mail(to: email, subject: "New Member joined")
  end

  def rejected_request_email_notification  email,user_name
    @email = email
    @first_name = user_name
    @messages = "Your request to upgrade your Tedercon Plan was rejected by company admin."
    mail(to: email, subject: "Rejected Upgrade Request")
  end

  def approved_request_email_notification  email,user_name,role
    @email = email
    @first_name = user_name
    if role == 'admin'
      @messages = "Company admin upgraded your Tendercon Plan."
    else
      @messages = "Your request to upgrade your Tedercon Plan was approved by company admin."
    end

    mail(to: email, subject: "Approved Upgrade Request")
  end

  def tender_trade_email_rejected  email,user_name,trade
    @email = email
    @first_name = user_name
    @messages = "Your request quote for #{trade} is rejected."

    mail(to: email, subject: "Trade Quotes Rejected")
  end

  def home_notifcation subject,email,new_email,company,name,position,messages=nil
    @email = email
    @new_email = new_email
    @company =  company
    @name = name
    @position = position
    @messages = messages.present? ? messages : "New Notification."
    mail(to: email, subject: "#{subject}")
  end

  def get_in_touch subject,email,new_email,name,msg
    @email = email
    @new_email = new_email
    @name = name
    @messages = msg
    mail(to: email, subject: "#{subject}")
  end

  def tender_changed subject,details,email,first_name,tender_title,addenda_type
    subject = "#{subject} Addenda added."
    @first_name = first_name
    @messages = "Addenda added from project #{tender_title}"
    @details =  details
    @type = addenda_type
    mail(to: email, subject: subject )
  end
end