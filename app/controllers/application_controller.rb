class ApplicationController < ActionController::API
  before_action :authenticate
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param_error

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def missing_param_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  private

  def authenticate
    @current_user = AuthorizationIssuer.new(request.headers).call
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
