class UnauthenticatedController < ActionController::Metal
  def self.call(env)
    @respond ||= action(:respond)
    @respond.call(env)
  end

  def respond
    self.status        = :unauthorized
    self.content_type  = 'application/json'
    self.response_body = { error: 'Unauthorized Request' }.to_json
  end
end
