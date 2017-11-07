require 'rails_helper'

RSpec.describe ApplicationController do
  let!(:user) do
    User.create(email: 'user@example.com', password: 'password')
  end

  describe 'rescue_from #not_found' do
    controller do
      skip_before_action :authenticate

      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it 'returns 404 and error message' do
      get :index
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)).to eq('error' => 'Not Found')
    end
  end

  describe 'rescue_from #missing_param_error' do
    controller do
      skip_before_action :authenticate

      def create
        raise ActionController::ParameterMissing.new(:name)
      end
    end

    it 'returns 404 and error message' do
      post :create
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq('error' => 'param is missing or the value is empty: name')
    end
  end

  describe '#authenticate' do
    controller do
      def index
        render json: [{ name: 'John Doe' }]
      end
    end

    it 'returns 200 when authenticated' do
      allow_any_instance_of(AuthorizationIssuer).to receive(:call)
        .and_return(user)

      get :index
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([{ 'name' => 'John Doe' }])
    end

    it 'returns 401 and error message when not authenticated' do
      allow_any_instance_of(AuthorizationIssuer).to receive(:call)
        .and_return(nil)

      get :index
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)).to eq('error' => 'Not Authorized')
    end
  end
end
