require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:jwt_token) do
    TokenIssuer.new('user@example.com', 'password').call
  end

  let(:valid_attributes) do
    { email: user.email, password: 'password' }
  end

  let(:invalid_attributes) do
    { email: user.email, password: 'not-the-right-password' }
  end

  let(:parsed_response) { JSON.parse(response.body) }

  describe 'POST #create' do
    context 'with valid credentials' do
      before { post :create, params: valid_attributes, format: :json }

      it { expect(response).to be_success }
      it { expect(parsed_response).to eq('auth_token' => jwt_token) }
    end

    context 'with invalid credentials' do
      before { post :create, params: invalid_attributes, format: :json }

      it { expect(response.status).to eq(401) }
    end
  end
end
