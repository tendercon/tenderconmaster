class CalendarsController < ApplicationController
  SCOPES = [ 'openid', 'profile', 'offline_access', 'https://outlook.office.com/mail.read','https://outlook.office.com/calendars.read' ]

  def index
    #begin
      token = get_access_token
      email = session[:user_email]

      if token.present?
        if token
          # If a token is present in the session, get messages from the inbox
          conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger
            faraday.adapter  Faraday.default_adapter
          end

          response = conn.get do |request|
            request.url '/api/v2.0/Me/Events?$orderby=Start/DateTime asc&$select=Subject,Start,End&$top=10'
            request.headers['Authorization'] = "Bearer #{token}"
            request.headers['Accept'] = "application/json"
          end

          @events = JSON.parse(response.body)['value']
          puts "@events----------------> #{@events}"

          @calendar_array = []
          @events_array = []
          @today_event = []
          if @events.present?
            puts "@events:#{@events.size}"
            #GoogleCalendarEvent.where(:email => session[:email]).delete_all
            @events.each_with_index do |e,index|

              puts "events_array:#{@events_array.uniq}"
              puts "events_array:#{@events_array.uniq.size}"
              @events_array <<  e['Subject']
                hash_data = {
                    title:"#{e['Subject']}",
                    url: "http://www.example.com",
                    class: "event-success",
                    start: "#{(e['Start']['DateTime'].to_datetime).strftime("%Q")}",
                    end:"#{(e['End']['DateTime'].to_datetime).strftime("%Q")}"
                }

                puts "#{(e['Start']['DateTime'].to_datetime).strftime("%Y-%m-%d")}"
                 puts "#{(Time.now).strftime("%Y-%m-%d")}"
                if (e['Start']['DateTime'].to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")   ||  (e['End']['DateTime'].to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")
                  hash_today = {
                      title:"#{e['Subject']}",
                      url: "http://www.example.com",
                      class: "event-success",
                      start: "#{(e['Start']['DateTime'].to_datetime).strftime("%Q")}",
                      end:"#{(e['End']['DateTime'].to_datetime).strftime("%Q")}"
                  }



                  @today_event <<  hash_today
                end
              puts "e['Start']['DateTime']:#{e['Start']['DateTime']}"
              puts "e['End']['DateTime']:#{e['End']['DateTime']}"

               google_events = GoogleCalendarEvent.new
               google_events.summary = e['Subject']
               google_events.start_date = (e['Start']['DateTime'])
               google_events.end_date =(e['End']['DateTime'])
               google_events.token = token
               google_events.email = session[:email]
               google_events.user_id = session[:user_logged_id]
               google_events.save


              @calendar_array << hash_data
            end
            puts "calendar_array: ---------------------->#{@calendar_array.inspect}"
            google_events = GoogleCalendarEvent.where(:user_id => session[:user_logged_id])
            if google_events.present?
              google_events.each_with_index do |a,index|
                @events_array <<  a.summary
                hash_data = {
                    title:"#{a.summary}",
                    url: "#",
                    class: "event-important",
                    start: "#{(a.start_date.to_datetime).strftime("%Q")}",
                    end:"#{(a.end_date.to_datetime).strftime("%Q")}"
                }
                #puts "#{((a.start_date.to_datetime).to_datetime).strftime("%Y-%m-%d")}"
                #puts "#{(Time.now).strftime("%Y-%m-%d")}"
                if ((a.start_date.to_datetime).to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")  || (a.end_date.to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")
                  hash_today = {
                      title:"#{e['Subject']}",
                      url: "http://www.example.com",
                      class: "event-success",
                      start: "#{(a.start_date.to_datetime).strftime("%Q")}",
                      end:"#{(a.end_date.to_datetime).strftime("%Q")}"
                  }

                  @today_event <<  hash_today
                end

                @calendar_array << hash_data
                puts "start_date:#{(a.start_date.to_datetime).strftime("%Q")}"
              end
            end
            puts "@calendar_array ----------->#{@calendar_array.inspect}"
            puts "@today_event--------------------->:#{@today_event.inspect}"

            event_title = Hash.new

            if @events_array.present?
              @events_array.uniq.each do |a|
                event_title["#{a}"] = a
              end
            end

            @calendar_array.each do |a|
              if a[:title] == event_title["#{a[:title]}"]
                if @events_array.index("#{a[:title]}") == 0
                  a[:class] = "event-important"
                elsif @events_array.index("#{a[:title]}") == 1
                  a[:class] = "event-success"
                elsif @events_array.index("#{a[:title]}") == 2
                  a[:class] = "event-inverse"
                elsif @events_array.index("#{a[:title]}") == 3
                  a[:class] = "event-special"
                elsif @events_array.index("#{a[:title]}") == 4
                  a[:class] = "event-warning"
                elsif @events_array.index("#{a[:title]}") == 5
                  a[:class] = "event-danger"
                elsif @events_array.index("#{a[:title]}") == 6
                  a[:class] = "event-primary"
                elsif @events_array.index("#{a[:title]}") == 7
                  a[:class] = "event-default"
                elsif @events_array.index("#{a[:title]}") == 8
                  a[:class] = "event-link"
                elsif @events_array.index("#{a[:title]}") == 9
                  a[:class] = "event-comment"
                end
              end
            end
          end

          @tenders = Tender.where(:user_id => session[:user_logged_id])
        else
          redirect_to :back
        end
      else
        google_events = GoogleCalendarEvent.where(:user_id => session[:user_logged_id])
        puts  "google_events:#{google_events.inspect}"
        @events_array = []
        @today_event = []
        @calendar_array = []
        if google_events.present?
          google_events.each_with_index do |a,index|
            @events_array <<  a.summary
            hash_data = {
                title:"#{a.summary}",
                url: "#",
                class: "event-important",
                start: "#{(a.start_date.to_datetime).strftime("%Q")}",
                end:"#{(a.end_date.to_datetime).strftime("%Q")}"
            }
            #puts "#{((a.start_date.to_datetime).to_datetime).strftime("%Y-%m-%d")}"
            #puts "#{(Time.now).strftime("%Y-%m-%d")}"
            if ((a.start_date.to_datetime).to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")  || (a.end_date.to_datetime).strftime("%Y-%m-%d") == (Time.now).strftime("%Y-%m-%d")
              hash_today = {
                  title:"#{e['Subject']}",
                  url: "http://www.example.com",
                  class: "event-success",
                  start: "#{(a.start_date.to_datetime).strftime("%Q")}",
                  end:"#{(a.end_date.to_datetime).strftime("%Q")}"
              }

              @today_event <<  hash_today
            end

            @calendar_array << hash_data
            puts "start_date:#{(a.start_date.to_datetime).strftime("%Q")}"
          end
        end
        puts "@calendar_array ----------->#{@calendar_array.inspect}"
        puts "@today_event--------------------->:#{@today_event.inspect}"

        event_title = Hash.new

        if @events_array.present?
          @events_array.uniq.each do |a|
            event_title["#{a}"] = a
          end
        end

        @calendar_array.each do |a|
          if a[:title] == event_title["#{a[:title]}"]
            if @events_array.index("#{a[:title]}") == 0
              a[:class] = "event-important"
            elsif @events_array.index("#{a[:title]}") == 1
              a[:class] = "event-success"
            elsif @events_array.index("#{a[:title]}") == 2
              a[:class] = "event-inverse"
            elsif @events_array.index("#{a[:title]}") == 3
              a[:class] = "event-special"
            elsif @events_array.index("#{a[:title]}") == 4
              a[:class] = "event-warning"
            elsif @events_array.index("#{a[:title]}") == 5
              a[:class] = "event-danger"
            elsif @events_array.index("#{a[:title]}") == 6
              a[:class] = "event-primary"
            elsif @events_array.index("#{a[:title]}") == 7
              a[:class] = "event-default"
            elsif @events_array.index("#{a[:title]}") == 8
              a[:class] = "event-link"
            elsif @events_array.index("#{a[:title]}") == 9
              a[:class] = "event-comment"
            end
          end
        end

        puts "no email ---------------->"
      end
    #rescue
    #end
  end

  def gettoken
    puts "params[:code] ----->#{params[:code]}"
    token = get_token_from_code params[:code]
    session[:azure_token] = token.to_hash
    session[:user_email] = get_user_email token.token
    redirect_to calendars_path
  end

  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(ENV['OFFICE_ID'],
                                ENV['OFFICE_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => "https://etendercon.herokuapp.com/authorize",
                                       :scope => SCOPES.join(' '))

    if token.expired?
      new_token = token.refresh!
      # Save new token
      session[:azure_token] = new_token.to_hash
      access_token = new_token.token
    else
      access_token = token
    end
  end

  def get_access_token
    # Get the current token hash from session
    token_hash = session[:azure_token]
    puts "token_hash:#{token_hash}"
    puts "ENV['OFFICE_ID']:#{ENV['OFFICE_ID']}"
    client = OAuth2::Client.new(ENV['OFFICE_ID'],
                                ENV['OFFICE_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    if token_hash.present? && client.present?
      token = OAuth2::AccessToken.from_hash(client, token_hash)

      # Check if token is expired, refresh if so
      if token.expired?
        new_token = token.refresh!
        # Save new token
        session[:azure_token] = new_token.to_hash
        access_token = new_token.token
      else
        access_token = token.token
      end
    else
      nil
    end



  end

  def get_user_email(access_token)
    conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
      # Outputs to the console
      faraday.response :logger
      # Uses the default Net::HTTP adapter
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get do |request|
      # Get user's info from /Me
      request.url 'api/v2.0/Me'
      request.headers['Authorization'] = "Bearer #{access_token}"
      request.headers['Accept'] = 'application/json'
    end

    email = JSON.parse(response.body)['EmailAddress']
    puts  "email:-----------> #{email}"
  end

  def get_event_details
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    puts "@start_date:#{@start_date}"
    puts "@end_date#{@end_date}"
    start_date = (Time.at(@start_date.to_f / 1000).strftime("%Y-%m-%d"))
    end_date = ((Time.at(@end_date.to_f / 1000).strftime("%Y-%m-%d").to_datetime) - 1.day).strftime("%Y-%m-%d")
    puts "start_date:#{start_date}"
    puts "end_date:#{end_date}"

    token = get_access_token
    email = session[:user_email]

    if token.present?
      if token
        # If a token is present in the session, get messages from the inbox
        conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end

        response = conn.get do |request|
          request.url '/api/v2.0/Me/Events?$orderby=Start/DateTime asc&$select=Subject,Start,End&$top=10'
          request.headers['Authorization'] = "Bearer #{token}"
          request.headers['Accept'] = "application/json"
        end

        @events = JSON.parse(response.body)['value']

        puts "@events:#{@events.inspect }"
      end
    end



    puts "start_date:#{start_date}"
    puts "end_date:#{end_date}"
    @events.each_with_index do |e,index|
      puts (e['Start']['DateTime'].to_datetime).strftime("%Y-%m-%d")
      puts (e['End']['DateTime'].to_datetime).strftime("%Y-%m-%d")
      if (start_date >= (e['Start']['DateTime'].to_datetime).strftime("%Y-%m-%d"))  && (end_date <= (e['End']['DateTime'].to_datetime).strftime("%Y-%m-%d"))
        puts "e['Subject']:#{e['Subject']}"
      end
    end

    @google_event = GoogleCalendarEvent.where("email = '#{session[:email]}' && end_date >= '#{start_date}' && end_date < '#{end_date}'")
    @events_array = []
    if @google_event.present?
      @google_event.each do |a|
        @events_array  << a.summary
      end
    end


    client = Google::APIClient.new

    client.authorization.access_token = session[:google_oauth2]["credentials"]["token"]
    service = client.discovered_api('calendar', 'v3')

    @result = client.execute(
        :api_method => service.events.list,
        :parameters => {'calendarId' => 'primary'},
        :headers => {'Content-Type' => 'application/json'})

    events = @result.data.items

    #puts "session[:google_oauth2]sjahjdhsa-----------:#{events.inspect}"

    if events.present?
      events.each do |a|
        puts "a['start']['dateTime']:#{a['start']['dateTime']}"
        puts "a['start']['dateTime']:#{a['end']['dateTime']}"
      end
    end

    puts "google_event:#{@google_event.inspect}"
    @data = render :partial => 'calendars/event_details'
  end

  def create_new_event
    event_title = params[:event_title]
    event_desc  = params[:event_desc]
    category    = params[:category]
    datetime    = params[:datetime]
    timezone    = params[:timezone]
    repeat      = params[:repeat]

    event = CalendarEvent.new
    event.title = event_title
    event.description = event_desc
    event.category = category
    event.event_date = datetime
    event.timezone = timezone
    event.repeat = repeat
    event.user_id = session[:user_logged_id]

    if event.save
      render :json => { :state => 'valid'}
    end

  end

end