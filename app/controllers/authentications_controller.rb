class AuthenticationsController < ApplicationController
  # skip_before_action :authenticate_request, only: [:create]

  def create
    token = TokenIssuer.new(*auth_params).call

    if token
      render json: { auth_token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require([:email, :password])
  end
end
