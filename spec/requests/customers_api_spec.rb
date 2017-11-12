require 'rails_helper'

RSpec.describe 'Customers API endpoint', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:jwt_token) { TokenIssuer.new('user@example.com', 'password').call }

  let(:valid_headers) { { 'HTTP_AUTHORIZATION' => jwt_token } }
  let(:invalid_headers) { { 'HTTP_AUTHORIZATION' => 'invalid-jwt' } }

  let(:valid_attributes) do
    { full_name: 'John Doe', email: 'john.doe@example.com', phone: '123456789' }
  end

  let(:invalid_attributes) do
    { full_name: nil, email: 'john.doe@example.com', phone: '123456789' }
  end

  let!(:customer) { Customer.create(valid_attributes) }

  let(:parsed_response) { JSON.parse(response.body) }

  describe 'GET /customers' do
    it 'lists all the customers' do
      get customers_path, params: { format: :json }, headers: valid_headers

      expect(response).to have_http_status(200)
      expect(parsed_response).to eq([
                                      { 'id' => customer.id,
                                        'full_name' => 'John Doe',
                                        'email' => 'john.doe@example.com',
                                        'phone' => '123456789' }
                                    ])
    end

    it "doesn't list all the customers with invalid jwt" do
      get customers_path, params: { format: :json }, headers: invalid_headers

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')
    end
  end

  describe 'GET /customers/:id' do
    it 'gets a single customer' do
      get customer_path(customer), params: { format: :json }, headers: valid_headers

      expect(response).to have_http_status(200)
      expect(parsed_response).to eq('id' => customer.id,
                                    'full_name' => 'John Doe',
                                    'email' => 'john.doe@example.com',
                                    'phone' => '123456789')
    end

    it "doesn't get a single customer with invalid jwt" do
      get customer_path(customer), params: { format: :json }, headers: invalid_headers

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')
    end

    it "doesn't get a single customer with not existing id" do
      get customer_path('not-existing'), params: { format: :json }, headers: valid_headers

      expect(response).to have_http_status(404)
      expect(parsed_response).to eq('error' => 'Not Found')
    end
  end

  describe 'POST /customers' do
    it 'creates a new customer' do
      post customers_path,
           params: { customer: valid_attributes, format: :json },
           headers: valid_headers

      expect(response).to have_http_status(201)
      expect(parsed_response).to eq('id' => Customer.last.id,
                                    'full_name' => 'John Doe',
                                    'email' => 'john.doe@example.com',
                                    'phone' => '123456789')
    end

    it "doesn't create a new customer with invalid attributes" do
      post customers_path,
           params: { customer: invalid_attributes, format: :json },
           headers: valid_headers

      expect(response).to have_http_status(422)
      expect(parsed_response).to eq('error' => { 'full_name' => ["can't be blank"] })
    end

    it "doesn't create a new customer with invalid jwt" do
      post customers_path,
           params: { customer: valid_attributes, format: :json },
           headers: invalid_headers

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')
    end
  end

  describe 'PATCH /customers/:id' do
    it 'updates a customer' do
      patch customer_path(customer),
            params: { customer: { full_name: 'John F. Doe', phone: '234567890' }, format: :json },
            headers: valid_headers

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty

      expect(customer.reload.full_name).to eq('John F. Doe')
      expect(customer.reload.phone).to eq('234567890')
    end

    it "doesn't update a customer with nvalid attributes" do
      patch customer_path(customer),
            params: { customer: { full_name: '', phone: '234567890' }, format: :json },
            headers: valid_headers

      expect(response).to have_http_status(422)
      expect(parsed_response).to eq('error' => { 'full_name' => ["can't be blank"] })

      expect(customer.reload.full_name).to eq('John Doe')
      expect(customer.reload.phone).to eq('123456789')
    end

    it "doesn't update a customer with invalid jwt" do
      patch customer_path(customer),
            params: { customer: { full_name: 'John F. Doe' }, format: :json },
            headers: invalid_headers

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')

      expect(customer.reload.full_name).to eq('John Doe')
      expect(customer.reload.phone).to eq('123456789')
    end

    it "doesn't update a customer with not existing id" do
      patch customer_path('not-existing'),
            params: { customer: { full_name: 'John F. Doe', phone: '234567890' }, format: :json },
            headers: valid_headers

      expect(response).to have_http_status(404)
      expect(parsed_response).to eq('error' => 'Not Found')
    end
  end

  describe 'DELETE /customers/:id' do
    it 'deletes a customer' do
      delete customer_path(customer), params: { format: :json }, headers: valid_headers

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty

      expect { customer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't delete a customer with invalid jwt" do
      delete customer_path(customer), params: { format: :json }, headers: invalid_headers

      expect(response).to have_http_status(401)
      expect(parsed_response).to eq('error' => 'Unauthorized Request')
    end

    it "doesn't delete a customer with not existing id" do
      delete customer_path('not-existing'), params: { format: :json }, headers: valid_headers

      expect(response).to have_http_status(404)
      expect(parsed_response).to eq('error' => 'Not Found')
    end
  end
end
