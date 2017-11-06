require 'rails_helper'

RSpec.describe TokenIssuer, type: :service do
  let!(:user) do
    User.create(email: 'user@example.com', password: 'password')
  end

  describe '#call' do
    it 'calls JsonWebToken.encode' do
      expect(JsonWebToken).to receive(:encode)
        .with(user_id: user.id)
        .and_return('jwt-token')

      described_class.new('user@example.com', 'password').call
    end

    it 'returns the token' do
      allow(JsonWebToken).to receive(:encode)
        .with(user_id: user.id)
        .and_return('jwt-token')

      expect(described_class.new('user@example.com', 'password').call).to eq('jwt-token')
    end

    context 'with invalid credentials' do
      it "doesn't call JsonWebToken.encode" do
        expect(JsonWebToken).not_to receive(:encode)

        described_class.new('user@example.com', 'wrong-password').call
      end

      it "doesn't call JsonWebToken.encode" do
        expect(JsonWebToken).not_to receive(:encode)

        described_class.new('wrong-user@example.com', 'password').call
      end
    end
  end
end
