class TokenController < ApplicationController
  skip_before_action :verify_authenticity_token


  def get_token
    Twilio::Util::AccessToken.new(ENV['ACCOUNT_SID'], ENV['API_KEY_SID'], ENV['API_KEY_SECRET'], 7200, session[:user_logged_id])
  end

  def get_grant
    grant = Twilio::Util::AccessToken::IpMessagingGrant.new
    grant.endpoint_id = "Chatty:#{(session[:user_logged_id].to_s).gsub(" ", "_")}:browser"
    grant.service_sid = ENV['IPM_SERVICE_SID']
    grant
  end

  def create
    token = get_token
    grant = get_grant
    token.add_grant(grant)

    avatar = Avatar.where(:user_id => session[:user_logged_id]).first

    if avatar.present?
      @avatar_name = avatar.image_file_name
      @profile_image = "http://"+request.host_with_port+"/assets/avatar/image/#{avatar.id}/original/#{@avatar_name}"
      render json: {username: session[:user_logged_id],avatar:@profile_image, token: token.to_jwt}
    else
      @profile_image = "https://s-media-cache-ak0.pinimg.com/236x/9a/de/a4/9adea4e40b39301576ff29f7ddebfd5b.jpg"
      render json: {username: session[:user_logged_id], avatar:@profile_image,token: token.to_jwt}
    end


  end

end