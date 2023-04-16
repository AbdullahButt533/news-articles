# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::TopicsController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:normal_user) { create(:user) }
  let(:headers) { admin_user.create_new_auth_token }

  describe 'When user is not admin' do
    let(:headers) { normal_user.create_new_auth_token }
    let!(:topic) { create(:topic) }

    it 'returns 403 status code' do
      delete "/api/v1/admin/topics/#{topic.id}", headers: headers
      expect(response.status).to eq(403)
    end
  end

  describe '#create' do
    context 'with valid params' do
      let(:params) { { title: 'Test Topic' } }

      it 'creates a new topic' do
        expect do
          post '/api/v1/admin/topics', params: { topic: params }, headers: headers
        end.to change(Topic, :count).by(1)
        expect(response.status).to eq(201)
        body = JSON.parse(response.body)
        expect(body['topic']['title']).to eq(params[:title])
      end
    end

    context 'with invalid params' do
      let(:params) { { title: nil } }

      it 'returns errors' do
        post '/api/v1/admin/topics', params: { topic: params }, headers: headers
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body['errors']).to be_present
      end
    end
  end

  describe '#update' do
    let!(:topic) { create(:topic) }
    let(:params) { { title: 'Updated Topic' } }

    context 'when topic exists' do
      it 'updates the topic' do
        put "/api/v1/admin/topics/#{topic.id}", params: { topic: params }, headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['topic']['title']).to eq(params[:title])
      end
    end

    context 'when topic does not exist' do
      it 'returns 404 status code' do
        put '/api/v1/admin/topics/0', params: { topic: params }, headers: headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#destroy' do
    let!(:topic) { create(:topic) }

    context 'when topic exists' do
      it 'destroys the topic' do
        expect do
          delete "/api/v1/admin/topics/#{topic.id}", headers: headers
        end.to change(Topic, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end
  end
end
