class AuthenticationsController < ApplicationController
  def create
    token = TokenIssuer.new(*auth_params).call

    if token
      render json: { auth_token: token }, status: :ok
    else
      render json: { error: 'Invalid Credentials' }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.require(%i[email password])
  end
end
