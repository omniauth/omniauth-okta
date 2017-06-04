require 'spec_helper'

describe OmniAuth::Strategies::Okta do

  subject { described_class.new({}) }

  let(:base_url) { 'https://your-org.okta.com' }

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
        eq("#{base_url}/oauth2/v1/authorize")
      end

      it 'has default token url' do
        expect(subject.options.client_options.token_url).to \
        eq("#{base_url}/oauth2/v1/token")
      end

      it 'has default response_type' do
        expect(subject.options.client_options.response_type).to \
        eq('id_token')
      end
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to \
      eq('/auth/okta/callback')
    end
  end

  describe '#scope' do
    it { expect(subject.authorize_params[:scope]).to eq('email') }
  end

  describe '#uid' do
    before :each do
      # allow(subject).to receive(:raw_info) { { 'id' => 'uid' } }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('uid')
    end
  end

  describe '#info' do
    before :each do
      allow(subject).to receive(:raw_info) { {} }
    end

    context 'and therefore has all the necessary fields' do
      it { expect(subject.info).to have_key :name }
      it { expect(subject.info).to have_key :email }
      it { expect(subject.info).to have_key :nickname }
      it { expect(subject.info).to have_key :first_name }
      it { expect(subject.info).to have_key :last_name }
      it { expect(subject.info).to have_key :location }
      it { expect(subject.info).to have_key :description }
      it { expect(subject.info).to have_key :image }
      it { expect(subject.info).to have_key :urls }
    end
  end

  describe '#extra' do
  end
end
