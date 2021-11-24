require 'ostruct'
require 'spec_helper'

RSpec.describe HTTP::RestClient do
  let(:base_client) do
    Class.new do
      extend HTTP::RestClient::DSL

      endpoint 'https://httpbin.org'
      path 'anything'
      content_type 'application/json'
      basic_auth user: 'user1', pass: 'pass1'
    end
  end

  let(:client) do
    Class.new(base_client)
  end

  let(:error_client) do
    Class.new(OpenStruct) do
      extend HTTP::RestClient::DSL

      endpoint 'https://httpbin.org'
      path 'anything'
      content_type 'application/json'
      accept 'application/json'

      def self.error_response?(_, _)
        true
      end
    end
  end

  context 'GET /' do
    it do
      response = client.request(
        :get, client.uri, json: { is_json: true }, params: { param1: true }
      )

      expect(response).to be_a(Hash)
      expect(response['method']).to eq('GET')
      expect(response['headers'].keys).to include('Authorization')
      expect(response['url']).to eq('https://httpbin.org/anything?param1=true')
      expect(response['args']).to eq('param1' => 'true')
      expect(response['json']).to eq('is_json' => true)
      expect(response['data']).to eq({ is_json: true }.to_json)
    end
  end

  context 'POST /path1' do
    it do
      client.headers.clear
      response = client.request(:get, client.uri(:path1), form: { is_form: 1 })

      expect(response).to be_a(Hash)
      expect(response['method']).to eq('GET')
      expect(response['url']).to eq('https://httpbin.org/anything/path1')
      expect(response['args']).to eq({})
      expect(response['form']).to eq('is_form' => '1')
      expect(response['data']).to eq('')
    end
  end

  context 'error handling' do
    it do
      expect { error_client.request(:get, error_client.uri) }
        .to raise_error(HTTP::RestClient::ResponseError, /200 OK/) do |err|
          expect(err.response_data).to be_a(Hash)
        end
    end
  end
end
