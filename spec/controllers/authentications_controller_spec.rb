require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:jwt_token) { TokenIssuer.new('user@example.com', 'password').call }

  let(:valid_credentials) do
    { email: user.email, password: 'password' }
  end

  let(:invalid_credentials) do
    { email: user.email, password: 'not-the-right-password' }
  end

  let(:parsed_response) { JSON.parse(response.body) }

  describe 'POST #create' do
    context 'with valid credentials' do
      before { post :create, params: valid_credentials, format: :json }

      it { expect(response).to have_http_status(200) }
      it { expect(parsed_response).to eq('auth_token' => jwt_token) }
    end

    context 'with invalid credentials' do
      before { post :create, params: invalid_credentials, format: :json }

      it { expect(response).to have_http_status(401) }
      it { expect(parsed_response).to eq('error' => 'Invalid Credentials') }
    end

    context 'with missing parameters' do
      before { post :create, params: { email: user.email }, format: :json }

      it { expect(response).to have_http_status(422) }
      it { expect(parsed_response).to eq('error' => 'param is missing or the value is empty: password') }
    end
  end
end
