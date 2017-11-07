require 'json_web_token'

class TokenIssuer
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: _user.id) if _user
  end

  private

  def _user
    user = User.find_by_email(@email)
    return user if user && user.authenticate(@password)
    nil
  end
end
