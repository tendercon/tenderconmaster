class DashboardController < ApplicationController

  def index
    a = Time.now.end_of_day - Time.now
    puts "a =========> #{a}"
    if session[:role] == 'Admin'
      @users_count = User.all.count()
      @users_completed = User.where("abn is not null").count();
      @users_incompleted = User.where("abn is  null").count();
      @users_deleted = User.where(:status => 'deleted').count();
      @completed_percentage = (@users_completed.to_f / @users_count.to_f).to_f * 100
    elsif session[:role] == 'Head Contractor'
      @tenders = Tender.where(:user_id => session[:user_logged_id])
      @month_hash = {}
      @tender_array = []

      if @tenders.present?
        @tenders.each_with_index do |t,index|
          num_1 =[]
          num_2 =[]
          num_3 =[]
          num_4 =[]
          num_5 =[]
          num_6 =[]
          num_7 =[]
          num_8 =[]
          num_9 =[]
          num_10 = []
          num_11 = []
          num_12 = []
          @tender_array << t.title
          if ((t.created_at).strftime("%m")).to_i == 1
            num_1 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 2
            num_2 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 3
            num_3 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 4
            num_4 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 5
            num_5 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 6
            num_6 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 7
            num_7 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 8
            num_8 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 9
            num_9 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 10
            num_10 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 11
            num_11 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          if ((t.created_at).strftime("%m")).to_i == 12
            num_12 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
          end

          new_arr = []
          new_arr << num_1.size
          new_arr << num_2.size
          new_arr << num_3.size
          new_arr << num_4.size
          new_arr << num_5.size
          new_arr << num_6.size
          new_arr << num_7.size
          new_arr << num_8.size
          new_arr << num_9.size
          new_arr << num_10.size
          new_arr << num_11.size
          new_arr << num_12.size

          @month_hash["#{t.title}"] =  new_arr
        end
        @hash_arr = []
        if @tender_array.present?
          @tender_array.each_with_index do |t,index|
            @hash_arr <<  {
              "name" => "#{t}",
              "data" => @month_hash["#{t}"]
            }
          end
        end
      end
    elsif session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'
      tender_request = TenderRequestQuote.where(:sc_id => session[:user_logged_id])
      @user_quote = TenderRequestQuote.where(:sc_id => session[:user_logged_id]).last
      @tender_count = Tender.all.count()
      if @user_quote.present?
        @range_month = (@user_quote.created_at + 1.month).strftime("%Y-%m-%d")
      else
        @range_month = nil
      end

      @tender_name = []
      @month_hash = {}
      @tender_array = []
      if tender_request.present?
        tender_request.each do |t|
          tender = Tender.find(t.tender_id)
          if !@tender_name.include? tender.title
            num_1 =[]
            num_2 =[]
            num_3 =[]
            num_4 =[]
            num_5 =[]
            num_6 =[]
            num_7 =[]
            num_8 =[]
            num_9 =[]
            num_10 = []
            num_11 = []
            num_12 = []
            @tender_array << tender.title
            if ((t.created_at).strftime("%m")).to_i == 1
              num_1 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 2
              num_2 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 3
              num_3 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 4
              num_4 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 5
              num_5 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 6
              num_6 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 7
              num_7 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 8
              num_8 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 9
              num_9 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 10
              num_10 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 11
              num_11 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            if ((t.created_at).strftime("%m")).to_i == 12
              num_12 << ((t.created_at).strftime("%m")).to_i.present? ? ((t.created_at).strftime("%m")).to_i : 0
            end

            new_arr = []
            new_arr << num_1.size
            new_arr << num_2.size
            new_arr << num_3.size
            new_arr << num_4.size
            new_arr << num_5.size
            new_arr << num_6.size
            new_arr << num_7.size
            new_arr << num_8.size
            new_arr << num_9.size
            new_arr << num_10.size
            new_arr << num_11.size
            new_arr << num_12.size
            @month_hash["#{tender.title}"] =  new_arr
          end
        end

        @hash_arr =[]
        if @tender_array.present?
          @tender_array.each_with_index do |t,index|
            @hash_arr <<  {
              "name" => "#{t}",
              "data" => @month_hash["#{t}"]
            }
          end
        end
      end
    else

    end

    #oauth = LinkedIn::OAuth2.new(ENV["LINKEDIN_CLIENT_ID"],ENV["LINKEDIN_CLIENT_SECRET"])
    #url = oauth.auth_code_url
    #puts("URL:#{url.inspect}")
    #code = "AQSDvoQhY-DKZkTBWwmxsQjw6uBjNlRy1jvywibhfJTvpEa0793LiZcctwuEkNLgBWABkrTdRM52_ItEFaiydCnoDTxWNjoPTgqlmRPolzzRI7mXyjQ"
    #access_token = oauth.get_access_token(code)
    #puts "access_token:#{access_token}"
  end

end