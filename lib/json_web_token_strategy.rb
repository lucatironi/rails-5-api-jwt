require 'json_web_token'

class JsonWebTokenStrategy < ::Warden::Strategies::Base
  def valid?
    env['HTTP_AUTHORIZATION'].present?
  end

  def authenticate!
    if _user
      success!(_user)
    else
      fail!('Authentication failed for token')
    end
  end

  def store?
    false
  end

  private

  def _user
    @user ||= User.find(_decoded_jwt[:user_id]) if _decoded_jwt
  end

  def _decoded_jwt
    @decoded_auth_token ||= JsonWebToken.decode(_jwt_from_header)
  end

  def _jwt_from_header
    env['HTTP_AUTHORIZATION'].split(' ').last
  end
end
