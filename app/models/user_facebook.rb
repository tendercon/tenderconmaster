class UserFacebook < ActiveRecord::Base

  def self.from_omniauth(auth,user_id)
    facebook_user = where(:email => auth.info.email).first

    if !facebook_user.present?
      where(provider:auth.provider, uid: auth.uid).first_or_create do |u|
        u.provider = auth.provider unless auth.info.blank?
        u.uid = auth.uid unless auth.info.blank?
        u.name = auth.info.name unless auth.info.blank?
        u.email = auth.info.email unless auth.info.blank?
        u.user_id = user_id
        u.oauth_token = auth.credentials.token unless auth.info.blank?
        u.oauth_expires_at = (auth.credentials.expires_at).present? ? Time.at(auth.credentials.expires_at) : ''
        u.save
      end
    end

  end
end