module CalendarsHelper

  SCOPES = [ 'openid', 'profile', 'offline_access', 'https://outlook.office.com/mail.read','https://outlook.office.com/calendars.read'  ]

  def get_login_url

      client = OAuth2::Client.new(ENV['OFFICE_ID'],
                                  ENV['OFFICE_SECRET'],
                                  :site => "https://login.microsoftonline.com",
                                  :authorize_url => "/common/oauth2/v2.0/authorize",
                                  :token_url => "/common/oauth2/v2.0/token")

      client.auth_code.authorize_url(:redirect_uri => 'http://etendercon.herokuapp.com/authorize', :scope => SCOPES.join(' '))

  end

  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(ENV['OFFICE_ID'],
                                ENV['OFFICE_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => "http://etendercon.herokuapp.com/authorize",
                                       :scope => SCOPES.join(' '))

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
  end

end