require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:jwt_token) { TokenIssuer.new('user@example.com', 'password').call }
  let!(:customer) { Customer.create(full_name: 'John Doe', email: 'john.doe@example.com') }

  let(:valid_headers) { { 'HTTP_AUTHORIZATION' => jwt_token } }
  let(:invalid_headers) { { 'HTTP_AUTHORIZATION' => 'invalid-jwt' } }

  describe 'GET /customers' do
    it 'lists all the customers' do
      get customers_path, params: { format: :json }, headers: valid_headers
      expect(response).to have_http_status(200)
    end

    it "doesn't list all the customers with invalid jwt" do
      get customers_path, params: { format: :json }, headers: invalid_headers
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET /customers/:id' do
    it 'gets a single customer' do
      get customer_path(customer), params: { format: :json }, headers: valid_headers
      expect(response).to have_http_status(200)
    end

    it "doesn't get a single customer with invalid jwt" do
      get customer_path(customer), params: { format: :json }, headers: invalid_headers
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST /customers' do
    it 'creates a new customer' do
      post customers_path,
           params: { customer: { full_name: 'John Doe', email: 'john.doe@example.com' },
                     format: :json },
           headers: valid_headers
      expect(response).to have_http_status(201)
    end

    it "doesn't create a new customer with invalid jwt" do
      post customers_path,
           params: { customer: { full_name: 'John Doe', email: 'john.doe@example.com' },
                     format: :json },
           headers: invalid_headers
      expect(response).to have_http_status(401)
    end
  end

  describe 'PUT /customers/:id' do
    it 'updates a customer' do
      patch customer_path(customer),
            params: { customer: { full_name: 'John F. Doe' }, format: :json },
            headers: valid_headers
      expect(response).to have_http_status(204)
    end

    it "doesn't update a customer with invalid jwt" do
      patch customer_path(customer),
            params: { customer: { full_name: 'John F. Doe' }, format: :json },
            headers: invalid_headers
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE /customers/:id' do
    it 'deletes a customer' do
      delete customer_path(customer), params: { format: :json }, headers: valid_headers
      expect(response).to have_http_status(204)
    end

    it "doesn't delete a customer with invalid jwt" do
      delete customer_path(customer), params: { format: :json }, headers: invalid_headers
      expect(response).to have_http_status(401)
    end
  end
end
