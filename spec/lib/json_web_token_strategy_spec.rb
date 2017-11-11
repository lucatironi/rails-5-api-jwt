require 'rails_helper'

RSpec.describe JsonWebTokenStrategy, type: :model do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }
  let!(:env) { { 'HTTP_AUTHORIZATION' => 'jwt-token' } }

  let(:subject) { described_class.new(nil) }

  describe '#valid?' do
    context 'with valid credentials' do
      before { allow(subject).to receive(:env).and_return(env) }

      it { is_expected.to be_valid }
    end

    context 'with invalid credentials' do
      before { allow(subject).to receive(:env).and_return({}) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#authenticate!' do
    before { allow(subject).to receive(:env).and_return(env) }

    context 'with valid credentials' do
      it 'succedes' do
        allow(JsonWebToken).to receive(:decode)
          .with('jwt-token')
          .and_return(user_id: user.id)

        expect(subject).to receive(:success!).with(user)
        subject.authenticate!
      end
    end

    context 'with invalid user' do
      it 'fails' do
        allow(JsonWebToken).to receive(:decode)
          .with('jwt-token')
          .and_return(user_id: user.id)
        allow(User).to receive(:find)
          .with(user.id)
          .and_return(nil)

        expect(subject).not_to receive(:success!)
        expect(subject).to receive(:fail!)
        subject.authenticate!
      end
    end

    context 'with invalid token' do
      it 'fails' do
        allow(JsonWebToken).to receive(:decode)
          .with('jwt-token')
          .and_return(nil)

        expect(subject).not_to receive(:success!)
        expect(subject).to receive(:fail!)
        subject.authenticate!
      end
    end
  end

  describe '#store?' do
    it { expect(subject).not_to be_store }
  end
end
