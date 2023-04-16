# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ArticlesController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:normal_user) { create(:user) }
  let(:headers) { admin_user.create_new_auth_token }
  let(:topic) { create(:topic) }
  let(:author) { create(:author) }
  let(:params) do
    {

      description: 'Test description',
      url: 'http://test.com',
      url_to_image: 'http://test.com/image.jpg',
      content: 'Test content',
      published_at: Time.zone.now,
      topic_id: topic.id,
      author_id: author.id,
      source: {},

    }
  end

  describe 'When user is not admin' do
    let(:headers) { normal_user.create_new_auth_token }
    let(:article) { create(:article) }

    it 'returns 403 status code' do
      delete "/api/v1/admin/articles/#{article.id}", headers: headers
      expect(response.status).to eq(403)
    end
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new article' do
        expect do
          post '/api/v1/admin/articles', params: { article: params }, headers: headers
        end.to change(Article, :count).by(1)
        expect(response.status).to eq(201)
        body = JSON.parse(response.body)
        expect(body['article']['url']).to eq(params[:url])
      end
    end

    context 'with invalid params' do
      it 'returns errors' do
        params[:url] = nil
        post '/api/v1/admin/articles', params: { article: params }, headers: headers
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body['errors']).to be_present
      end
    end
  end

  describe '#update' do
    let!(:article) { create(:article) }
    let(:params) { { description: 'Updated Author' } }

    context 'when article exists' do
      it 'updates the article' do
        put "/api/v1/admin/articles/#{article.id}", params: { article: params }, headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['article']['description']).to eq(params[:description])
      end
    end

    context 'when article does not exist' do
      it 'returns 404 status code' do
        put '/api/v1/admin/articles/0', params: { article: params }, headers: headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#destroy' do
    let!(:article) { create(:article) }

    context 'when article exists' do
      it 'destroys the article' do
        expect do
          delete "/api/v1/admin/articles/#{article.id}", headers: headers
        end.to change(Article, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end
  end
end
