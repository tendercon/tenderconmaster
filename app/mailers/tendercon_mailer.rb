class TenderconMailer < ActionMailer::Base
  #default from: 'agile.jjp@gmail.com'

  include SendGrid
  def reset_password(email,root_path,user_id)

     @user = User.find(user_id)
     @root_path = 'http://'#root_path
     @user_id = #user_id
     @email = email

     if @user.role == 'Sub Contractor'
       reset_password_path = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/users/reset_password?id=#{@user_id}&email=#{@email}"
     else
       reset_password_path = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/users/reset_password?id=#{@user_id}&email=#{@email}"
     end


     #reset_password_path = "http://#{root_path}/users/reset_password?id=#{@user_id}&email=#{@email}"
     headers "X-SMTPAPI" => {
         sub: {
             ":first_name" => [@user.first_name],
             ":link" => [reset_password_path]
         },
         filters: {
             templates: {
                 settings: {
                     enable: 1,
                     template_id: "e836d2f8-5690-4e70-b765-781990c568f5",
                 }
             }
         }
     }.to_json
     mail(from: 'support@tendercon.com', to: email, subject: 'Reset Password')
  end

  def reset_password_confirmation(email,user_id)
    @user = User.find(user_id)
    @user_id = user_id
    headers "X-SMTPAPI" => {
        sub: {
            ":first_name" => [@user.first_name]
        },
        filters: {
            templates: {
              settings: {
                enable: 1,
                template_id: "cb2bb0b6-e552-499b-9478-4ff0776970af",
              }
            }
        }
    }.to_json
    mail(from: 'support@tendercon.com', to: email, subject: 'Confirmation of Password Change')

  end

  def sent_sc_invites email,name,trade,path,decline_path,parent_id
    @parent = User.find(parent_id)
    #@tender = Tender.find(tender_id)
    #@tender_value = TenderValue.find(@tender.tender_value_id)
    @user = User.where(:email => email).first
    @name = name
    @email = email
    @path = path
    @decline_path = decline_path
    @trade = trade
    puts "path =======> #{path.inspect}"


    headers "X-SMTPAPI" => {
        sub: {
            ":sc_first_name" => [name],
            ":hc_first_name" => [@parent.first_name],
            ":hc_company_trade_name" => [@parent.trade_name],
            ":link1" => [path],
            ":link2" => [path]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: "1caed6e3-5c72-49db-9f6e-6b14070d7f16",
                }
            }
        }
    }.to_json
    mail(from: 'invite@tendercon.com', to: email)

  end

  def registration_email email,root_path,user_id,unique_key,path=nil
    user = User.find(user_id)
    @root_path = root_path
    @user_id = user_id
    @email = user.first_name
    @unique_key = unique_key
    @messages = 'You are successfully registered to Tendercon'
    if path.present?
      @link = path
    else
      if user.role == "Sub Contractor"
        @link = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/users/validate_account?id=#{@user_id}&email=#{@email}&token=#{@unique_key}"
      else
        @link = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/users/validate_account?id=#{@user_id}&email=#{@email}&token=#{@unique_key}"
      end

    end

    headers "X-SMTPAPI" => {
        sub: {
            ":first_name" => [user.first_name],
            ":link" => [@link]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: "1402c629-ff6f-4d76-8fd6-554aae04e360",
                }
            }
        }
    }.to_json

    mail(from: 'invite@tendercon.com', to: email, subject: 'Account Verification ')

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

  def welcome_email email,user_id,root_url
    @user = User.find(user_id)
    @user_id = user_id
    @email = email
    #@messages = "Welcome to Tendercon! Thanks so much for joining us. Happy tendering."
    #mail(to: email, subject: 'Welcome to Tendercon')

    if @user.role == 'Sub Contractor'
      @template_id = "e162a004-e3a7-4dc2-94e1-778b15e96da1"
      @root_path_link = "http://subcontractor.tendercon.com/dashboard?user=#{user_id}"
    else
      @template_id = "f83ebfb0-9566-4b2a-8c88-7082307570f8"
      @root_path_link = "http://builder.tendercon.com/dashboard?user=#{user_id}"
    end



    headers "X-SMTPAPI" => {
        sub: {
            ":first_name" => [@user.first_name],
            ":link1" => [@root_path_link],
            ":link2" => [@root_path_link],
            ":company_trade_name" => [@user.trade_name]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: @template_id,
                }
            }
        }
    }.to_json
    mail(from: 'hello@tendercon.com', to: email, subject: 'Welcome')
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

  def sent_invitation_email email,admin_name,user_invited_name,path,company_name,user_id,parent_id
    @user = User.find(user_id)
    @parent = User.find(parent_id)
    @user_id = user_id
    @email = email
    @path = path
    @first_name = user_invited_name
    #@messages = "#{admin_name} has invited you to be part of #{company_name}. "
    #@root_path = "http://#{path}/invites/registration?id=#{@user_id}"

    if @user.role == 'Sub Contractor'
      @root_path = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/invites/registration?id=#{@user_id}"
    else
      @root_path = "http://ec2-13-54-38-164.ap-southeast-2.compute.amazonaws.com/invites/registration?id=#{@user_id}"
    end


    if @user.role == 'Sub Contractor'
      @subject = "SC Admin Invites Team Member"
      @template_id = "a7cda2b3-a718-4aa1-8217-77952bb9018a"
      source = {
          ":invited_sc_first_name" => [user_invited_name],
          ":inviter_sc_first_name" => [@parent.first_name],
          ":sc_company_trade_name" => [@parent.trade_name],
          ":link1" => [@root_path],
          ":link2" => [@root_path]
      }
    else
      @subject = "HC Admin Invites Team Member"
      @template_id = "3258380e-d7fd-44a9-a724-f506b416dd7c"
      source = {
          ":invited_hc_first_name" => [user_invited_name],
          ":Inviter_hc_first_name" => [@parent.first_name],
          ":HC_Company_Trade_name" => [@parent.trade_name],
          ":link1" => [@root_path],
          ":link2" => [@root_path]
      }
    end


    headers "X-SMTPAPI" => {
        sub: source,
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: @template_id,
                }
            }
        }
    }.to_json

    mail(from: 'invite@tendercon.com', to: email, subject: @subject)
  end

  def sent_request_upgrade email,user_name,plan,admin_name
    @email = email
    @first_name = admin_name
    @messages = "Your team member #{user_name} requested to upgrade his plan to #{plan}"
    mail(to: email, subject: "Request upgrade plan")

  end

  def sc_upgrade_plan email,user_name,plan,admin_name
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

  def tender_changed sc_id,tender,addenda_issued,path

    @user  = User.find(sc_id)
    @tender = Tender.find(tender)
    headers "X-SMTPAPI" => {
        sub: {
            ":tender_title" => [@tender.title],
            ":tendering_sc_first_name" => [@user.first_name],
            ":head_first_name" => [@tender.user.first_name],
            ":addenda_published_time" => [addenda_issued],
            ":link" => [path]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '2dab32ee-8c06-4cf2-a2fc-58140140f4d0',
                }
            }
        }
    }.to_json
    mail(from: 'tenders@tendercon.com', to: @user.email)
  end

  def sent_quotes sc_id,tender,quote_trade,path
    @user  = User.find(sc_id)
    @tender = Tender.find(tender)
    headers "X-SMTPAPI" => {
        sub: {
            ":tender_title" => [@tender.title],
            ":sc_company_trade_name" => [@user.trade_name],
            ":submitted_quote_sc_first_name" => [@user.first_name],
            ":hc_first_name" => [@tender.user.first_name],
            ":quote_trade" => [quote_trade],
            ":link" => [path]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: '73fdbf6e-a21e-4a6e-85a5-abf1cf7acbd9',
                }
            }
        }
    }.to_json
    mail(from: 'tenders@tendercon.com', to: @tender.user.email)

  end


  def invites_publish_tender invited_email,invited_name,trade,path,decline_path,tender,url_with_port,parent_id

    tender = Tender.find(tender)
    tender_value = TenderValue.find(tender.tender_value_id)
    puts "invited_email =======> #{invited_email}"
    puts "tender =======> #{tender.inspect}"
    @parent = User.find(tender.user_id)

    headers "X-SMTPAPI" => {
        sub: {
            ":invited_sc_first_name" => [invited_name],
            ":hc_first_name" => [@parent.first_name],
            ":hc_company_trade_name" => [@parent.trade_name],
            ":tender_details_city" => [tender.address],
            ":tender_Project_Value_Range" => [tender_value.range],
            ":invited_trade_name" => [trade],
            ":tender_details_quote_due_date" => [tender.tender_quote.quote_date],
            ":link1" => [path],
            ":link2" => [decline_path],
            ":link3" => [url_with_port]
        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: "bf4d8810-3a64-4d4c-bd9f-9cc0a26406e8",
                }
            }
        }
    }.to_json

    mail(from: 'invite@tendercon.com', to: invited_email)
  end


  def sc_upgrade_plan email,path,name
    headers "X-SMTPAPI" => {
        sub: {
            ":upgraded_sc_first_name" => [name],
            ":link" => [path],

        },
        filters: {
            templates: {
                settings: {
                    enable: 1,
                    template_id: "2f080687-cc96-424b-94cd-30c874c84c10",
                }
            }
        }
    }.to_json

    mail(from: 'hello@tendercon.com', to: email)

  end

end