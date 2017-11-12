require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:jwt_token) { TokenIssuer.new('user@example.com', 'password').call }

  let(:parsed_response) { JSON.parse(response.body) }

  describe 'POST /authentications' do
    it 'logs in the user and return the JSON Web Token' do
      post authentications_path, params: { email: user.email, password: 'password', format: :json }

      expect(response).to have_http_status(200)
      expect(parsed_response).to eq('auth_token' => jwt_token)
    end

    it "doesn't log in the user with invalid credentials" do
      post authentications_path, params: { email: user.email, password: 'not-password', format: :json }

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')
    end

    it "doesn't log in the user with missing parameters" do
      post authentications_path, params: { email: user.email, format: :json }

      expect(response).to have_http_status(422)
      expect(parsed_response).to eq('error' => 'param is missing or the value is empty: password')
    end
  end
end
