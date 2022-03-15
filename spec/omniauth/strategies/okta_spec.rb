# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Okta do
  include OmniAuth::Test::StrategyTestCase
  subject { described_class.new({}) }

  let(:base_url) { 'https://your-org.okta.com' }
  let(:strategy) { described_class }

  describe '#client' do
    it 'has default site' do
      expect(subject.client.site).to eq(base_url)
    end

    context '.client_options' do
      it 'has default authorize url' do
        expect(subject.options.client_options.site).to \
        eq(base_url)
      end

      it 'has default authorize url' do
        expect(subject.options.client_options.authorize_url).to \
        eq("#{base_url}/oauth2/default/v1/authorize")
      end

      it 'has default token url' do
        expect(subject.options.client_options.token_url).to \
        eq("#{base_url}/oauth2/default/v1/token")
      end

      it 'has default response_type' do
        expect(subject.options.client_options.response_type).to \
        eq('id_token')
      end
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      post '/auth/okta'
      expect(last_response.location).to \
      eq('http://example.org/auth/okta/callback')
    end
  end

  describe '#uid' do
    before :each do
      allow(subject).to receive(:raw_info) { { 'sub' => 'uid' } }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('uid')
    end
  end

  describe '#info' do
    before :each do
      allow(subject).to receive(:raw_info) { {} }
    end

    context 'has the necessary fields' do
      it { expect(subject.info).to have_key :name }
      it { expect(subject.info).to have_key :email }
      it { expect(subject.info).to have_key :first_name }
      it { expect(subject.info).to have_key :last_name }
      it { expect(subject.info).to have_key :image }
    end
  end

  describe 'extra' do
    subject { described_class.new('app', skip_jwt: true) }

    before :each do
      allow(subject).to receive(:raw_info) { { :foo => 'bar' } }
      allow(subject).to receive(:access_token)
                          .and_return(
                            instance_double(::OAuth2::AccessToken,
                                            token:         nil,
                                            refresh_token: 'token',
                                            expires_in:    0,
                                            expires_at:    0))
      allow(subject).to receive(:oauth2_access_token)
                        .and_return(
                          ::OAuth2::AccessToken.new(
                            'client',
                            nil,
                            refresh_token: 'token',
                            expires_in:    0,
                            expires_at:    0,
                            'id_token' => 'id_token',
                          ),
                        )
    end

    it { expect(subject.extra[:raw_info]).to eq({ :foo => 'bar' }) }

    describe 'id_token' do
      it { expect(subject.extra[:id_token]).to eq('id_token') }
    end
  end

  describe 'raw_info' do
  end
end
