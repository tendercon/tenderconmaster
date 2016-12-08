class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @user = UserLinkedin.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
  end

  def create_user_facebook
    puts "params[:provider]:#{params[:provider]}"
    if params[:provider] == 'google_oauth2'
      session[:google_oauth2] = request.env["omniauth.auth"]
      @auth = request.env["omniauth.auth"]
      #Use the token from the data to request a list of calendars
      @token = @auth["credentials"]["token"]
      client = Google::APIClient.new

      client.authorization.access_token = @token
      service = client.discovered_api('calendar', 'v3')

      @result = client.execute(
          :api_method => service.events.list,
          :parameters => {'calendarId' => 'primary'},
          :headers => {'Content-Type' => 'application/json'})
      events = @result.data.items
      puts "@result -----> #{events.inspect}"

      if events.present?
        google_token = GoogleCalendarEvent.where(:token => @token).first

        if !google_token.present?
          events.each do |a|
            if a['start'].present? &&  a['summary'].present? && a['end'].present?
              google = GoogleCalendarEvent.new
              google.summary = a['summary']
              google.start_date = a['start']['dateTime']
              google.end_date = a['end']['dateTime']
              google.token = @token
              google.email = session[:email]
              google.user_id = session[:user_logged_id]
              google.save
            end
          end
        end
      end
      redirect_to calendars_path
    else
      user_facebook = UserFacebook.from_omniauth(env["omniauth.auth"],session[:user_logged_id])
      render json: user_facebook.email
    end

    #redirect_to edit_company_profile_users_path(:id => session[:user_logged_id],:email => user_facebook.email)
  end

  def destroy

    redirect_to :back

  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end