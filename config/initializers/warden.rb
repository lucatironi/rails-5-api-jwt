require 'json_web_token_strategy'

Warden::Strategies.add(:json_web_token, JsonWebTokenStrategy)

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :json_web_token
  manager.failure_app = UnauthenticatedController
end
