require 'rails_helper'
require 'json_web_token'

RSpec.describe JsonWebToken do
  describe '.encode' do
    let(:payload) { {} }

    it 'calls JWT.encode with payload and secret' do
      expect(JWT).to receive(:encode)
        .with(payload, Rails.application.secrets.secret_key_base)

      described_class.encode(payload)
    end

    it 'returns the token' do
      allow(JWT).to receive(:encode)
        .with(payload, Rails.application.secrets.secret_key_base)
        .and_return('jwt-token')

      expect(described_class.encode(payload)).to eq('jwt-token')
    end
  end

  describe '.decode' do
    let(:token) { 'jwt-token' }

    it 'calls JWT.decode with token and secret' do
      expect(JWT).to receive(:decode)
        .with(token, Rails.application.secrets.secret_key_base)

      described_class.decode(token)
    end

    it 'returns the decoded body' do
      allow(JWT).to receive(:decode)
        .with(token, Rails.application.secrets.secret_key_base)
        .and_return([{ foo: 'bar' }])

      expect(described_class.decode(token)).to eq('foo' => 'bar')
    end
  end
end
