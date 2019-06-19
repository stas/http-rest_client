require 'ostruct'
require 'securerandom'
require 'spec_helper'

RSpec.describe HTTP::RestClient::CRUD do
  let(:resource) do
    Class.new(OpenStruct) do
      extend HTTP::RestClient::DSL
      extend HTTP::RestClient::CRUD

      endpoint 'https://httpbin.org'
      path 'anything'
      content_type 'application/json'
      basic_auth user: 'user1', pass: 'pass1'
    end
  end

  let(:uid) { SecureRandom.uuid }

  context '#find' do
    it do
      response = resource.find(uid, param: 1)

      expect(response).to be_a(resource)
      expect(response['method']).to eq('GET')
      expect(response.headers.keys).to include('Authorization')
      expect(response.url).to eq("https://httpbin.org/anything/#{uid}?param=1")
      expect(response.args).to eq('param' => '1')
    end
  end

  context '#delete' do
    it do
      response = resource.delete(uid)

      expect(response).to be_a(resource)
      expect(response['method']).to eq('DELETE')
      expect(response.headers.keys).to include('Authorization')
      expect(response.url).to eq("https://httpbin.org/anything/#{uid}")
    end
  end

  context '#update' do
    it do
      response = resource.update(uid, data: true)

      expect(response).to be_a(resource)
      expect(response['method']).to eq('PATCH')
      expect(response.headers.keys).to include('Authorization')
      expect(response.url).to eq("https://httpbin.org/anything/#{uid}")
      expect(response.data).to eq({ data: true }.to_json)
    end
  end

  context '#create' do
    it do
      response = resource.create(data: true)

      expect(response).to be_a(resource)
      expect(response['method']).to eq('POST')
      expect(response.headers.keys).to include('Authorization')
      expect(response.url).to eq('https://httpbin.org/anything')
      expect(response.data).to eq({ data: true }.to_json)
    end
  end

  context '#all' do
    it do
      response = resource.all(page: 1)

      expect(response).to be_a(resource)
      expect(response['method']).to eq('GET')
      expect(response.headers.keys).to include('Authorization')
      expect(response.url).to eq('https://httpbin.org/anything?page=1')
      expect(response.args).to eq('page' => '1')
    end
  end
end
