require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'rescue_from #not_found' do
    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it 'returns 404 and error message' do
      get :index
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq('error' => 'Not Found')
    end
  end

  describe 'rescue_from #missing_param_error' do
    controller do
      def create
        raise ActionController::ParameterMissing, :name
      end
    end

    it 'returns 404 and error message' do
      post :create
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)).to eq('error' => 'param is missing or the value is empty: name')
    end
  end
end
