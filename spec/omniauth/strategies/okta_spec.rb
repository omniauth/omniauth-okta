# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Okta do
  include OmniAuth::Test::StrategyTestCase
  subject { described_class.new({}) }

  let(:base_url) { 'https://your-org.okta.com' }
  let(:strategy) { described_class }
  let(:access_token_string) do
    "eyJhbGciOiJSUzI1NiJ9.eyJ2ZXIiOjEsImlzcyI6Imh0dHA6Ly9yYWluLm9rdGExLmNvbToxODAyIiwiaWF0IjoxNDQ5Nj" \
    "I0MDI2LCJleHAiOjE0NDk2Mjc2MjYsImp0aSI6IlVmU0lURzZCVVNfdHA3N21BTjJxIiwic2NvcGVzIjpbIm9wZW5pZCIsI" \
    "mVtYWlsIl0sImNsaWVudF9pZCI6InVBYXVub2ZXa2FESnh1a0NGZUJ4IiwidXNlcl9pZCI6IjAwdWlkNEJ4WHc2STZUVjRt" \
    "MGczIn0.HaBu5oQxdVCIvea88HPgr2O5evqZlCT4UXH4UKhJnZ5px-ArNRqwhxXWhHJisslswjPpMkx1IgrudQIjzGYbtLF" \
    "jrrg2ueiU5-YfmKuJuD6O2yPWGTsV7X6i7ABT6P-t8PRz_RNbk-U1GXWIEkNnEWbPqYDAm_Ofh7iW0Y8WDA5ez1jbtMvd-o" \
    "XMvJLctRiACrTMLJQ2e5HkbUFxgXQ_rFPNHJbNSUBDLqdi2rg_ND64DLRlXRY7hupNsvWGo0gF4WEUk8IZeaLjKw8UoIs-E" \
    "TEwJlAMcvkhoVVOsN5dPAaEKvbyvPC1hUGXb4uuThlwdD3ECJrtwgKqLqcWonNtiw"
  end

  let(:id_token_string) do
    "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwMHVpZDRCeFh3Nkk2VFY0bTBnMyIsImVtYWlsIjoid2VibWFzdGVyQGNsb3VkaXR1ZG" \
    "UubmV0IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInZlciI6MSwiaXNzIjoiaHR0cDovL3JhaW4ub2t0YTEuY29tOjE4MDIiLCJsb" \
    "2dpbiI6ImFkbWluaXN0cmF0b3IxQGNsb3VkaXR1ZGUubmV0IiwiYXVkIjoidUFhdW5vZldrYURKeHVrQ0ZlQngiLCJpYXQiOjE0" \
    "NDk2MjQwMjYsImV4cCI6MTQ0OTYyNzYyNiwiYW1yIjpbInB3ZCJdLCJqdGkiOiI0ZUFXSk9DTUIzU1g4WGV3RGZWUiIsImF1dGh" \
    "fdGltZSI6MTQ0OTYyNDAyNiwiYXRfaGFzaCI6ImNwcUtmZFFBNWVIODkxRmY1b0pyX1EifQ.Btw6bUbZhRa89DsBb8KmL9rfhku" \
    "--_mbNC2pgC8yu8obJnwO12nFBepui9KzbpJhGM91PqJwi_AylE6rp-ehamfnUAO4JL14PkemF45Pn3u_6KKwxJnxcWxLvMuuis" \
    "nvIs7NScKpOAab6ayZU0VL8W6XAijQmnYTtMWQfSuaaR8rYOaWHrffh3OypvDdrQuYacbkT0csxdrayXfBG3UF5-ZAlhfch1fhF" \
    "T3yZFdWwzkSDc0BGygfiFyNhCezfyT454wbciSZgrA9ROeHkfPCaX7KCFO8GgQEkGRoQntFBNjluFhNLJIUkEFovEDlfuB4tv_M" \
    "8BM75celdy3jkpOurg"
  end

  let(:okta_response) {
    {
      "access_token" => access_token_string,
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "scope"      => "openid email",
      "refresh_token" => "a9VpZDRCeFh3Nkk2VdY",
      "id_token" => id_token_string
    }
   }

  let(:access_token) { ::OAuth2::AccessToken.from_hash(subject.client, okta_response) }

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
    before do
      allow(subject).to receive(:raw_info) { { :foo => 'bar' } }
      allow(subject).to receive(:access_token).and_return(access_token)
    end

    it { expect(subject.extra[:raw_info]).to eq({ :foo => 'bar' }) }
    it { expect(subject.extra[:id_token]).to eq(id_token_string) }
    it { expect(subject.extra[:id_info]).to eq(
      {
        "sub" => "00uid4BxXw6I6TV4m0g3",
        "email" => "webmaster@clouditude.net",
        "email_verified" => true,
        "ver" => 1,
        "iss" => "http://rain.okta1.com:1802",
        "login" => "administrator1@clouditude.net",
        "aud" => "uAaunofWkaDJxukCFeBx",
        "iat" => 1449624026,
        "exp" => 1449627626,
        "amr" => ["pwd"],
        "jti" => "4eAWJOCMB3SX8XewDfVR",
        "auth_time" => 1449624026,
        "at_hash" => "cpqKfdQA5eH891Ff5oJr_Q"}
    )}
    it { expect(subject.access_token).to_not eq(subject.extra[:id_token]) }
  end

  describe 'id_token' do
    before do
      allow(subject).to receive(:access_token).and_return(access_token)
    end

    it { expect(subject.id_token).to eq(id_token_string) }

    context 'when access token is nil' do
      before do
        allow(subject).to receive(:access_token).and_return(nil)
      end

      it { expect(subject.id_token).to be_nil }
    end
  end

  describe 'raw_info' do
  end
end
