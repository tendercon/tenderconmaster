class UserSubscription < ActiveRecord::Base

  belongs_to :user


  def self.notify user_id,url_path
    @user = User.find(user_id)
    subscriber = self.where(:user_id => user_id).first

    if subscriber.present?
      diff = subscriber.expiry_date - Date.today
      path = "http://"+url_path+"/users/authenticate?email=#{@user.email}&credit_card=true"
      puts diff.to_i
      if diff.to_i > 30 && diff.to_i <= 60

        puts subscriber.inspect

        if subscriber.notify1 != true
          #TenderconMailer.credit_card_will_expire(@user.email,@user.id,path).deliver_now
          #self.where(:user_id => @user.id).update_all(:notify1 => true)
        end
      elsif diff.to_i > 7 && diff.to_i <= 30

        if subscriber.notify2 != true
          #TenderconMailer.credit_card_will_expire(@user.email,@user.id,path).deliver_now
          #self.where(:user_id => @user.id).update_all(:notify2 => true)
        end
      # elsif diff.to_i == 7
      #   if subscriber.notify2 != true
      #     TenderconMailer.credit_card_will_expire(@user.email,@user.id,path).deliver_now
      #     self.where(:user_id => @user.id).update_all(:notify2 => true)
      #   end
      end

    end
  end

  def self.update_action_type user_id
    UserSubscription.where(:user_id => user_id).update_all(:action_type => nil)
  end

end