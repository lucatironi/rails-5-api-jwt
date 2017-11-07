require 'json_web_token'

class AuthorizationIssuer
  def initialize(headers = {})
    @headers = headers
  end

  def call
    _user
  end

  private

  def _user
    User.find(_decoded_auth_token[:user_id]) if _decoded_auth_token
  end

  def _decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(_http_auth_header)
  end

  def _http_auth_header
    return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?
    nil
  end
end
