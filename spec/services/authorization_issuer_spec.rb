require 'rails_helper'

RSpec.describe AuthorizationIssuer, type: :service do
  let!(:user) do
    User.create(email: 'user@example.com', password: 'password')
  end

  let(:headers) { { 'Authorization' => 'jwt-token' } }

  describe '#call' do
    it 'returns the user from the token' do
      allow(JsonWebToken).to receive(:decode)
        .with('jwt-token')
        .and_return(user_id: user.id)

      expect(described_class.new(headers).call).to eq(user)
    end

    context 'with invalid/missing data' do
      it 'returns nil when the user is not found' do
        allow(JsonWebToken).to receive(:decode)
          .with('jwt-token')
          .and_return(user_id: user.id)
        allow(User).to receive(:find)
          .with(user.id)
          .and_return(nil)

        expect(described_class.new(headers).call).to be_nil
      end

      it 'returns nil when the token is invalid' do
        allow(JsonWebToken).to receive(:decode)
          .with('jwt-token')
          .and_return(nil)

        expect(described_class.new(headers).call).to be_nil
      end

      it 'returns nil when the headers are nil' do
        expect(described_class.new.call).to be_nil
      end
    end
  end
end
