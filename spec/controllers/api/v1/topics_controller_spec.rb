# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :request do
  describe 'when user is authenticated' do
    let!(:user) { create(:user) }
    let!(:topics) { create_list(:topic, 3) }
    let(:headers) { user.create_new_auth_token }

    context '#index' do
      it 'returns topics' do
        get '/api/v1/topics', headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['topics'].size).to eq(3)
        expect(body['meta']).to be_present
      end
    end

    context '#show' do
      it 'returns a topic' do
        topic = topics.first
        get "/api/v1/topics/#{topic.id}", headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['topic']).to be_present
        expect(body['topic']['title']).to eq(topic.title)
      end
    end
  end

  describe 'when user is not authenticated' do
    it 'returns 401 status code' do
      get '/api/v1/topics'
      expect(response.status).to eq(401)
    end
  end
end
