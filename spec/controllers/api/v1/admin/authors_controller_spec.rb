# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::AuthorsController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:normal_user) { create(:user) }
  let(:headers) { admin_user.create_new_auth_token }

  describe 'When user is not admin' do
    let(:headers) { normal_user.create_new_auth_token }
    let(:author) { create(:author) }

    it 'returns 403 status code' do
      delete "/api/v1/admin/authors/#{author.id}", headers: headers
      expect(response.status).to eq(403)
    end
  end

  describe '#create' do
    context 'with valid params' do
      let(:params) { { name: 'Test Author' } }

      it 'creates a new author' do
        expect do
          post '/api/v1/admin/authors', params: { author: params }, headers: headers
        end.to change(Author, :count).by(1)
        expect(response.status).to eq(201)
        body = JSON.parse(response.body)
        expect(body['author']['name']).to eq(params[:name])
      end
    end

    context 'with invalid params' do
      let(:params) { { name: nil } }

      it 'returns errors' do
        post '/api/v1/admin/authors', params: { author: params }, headers: headers
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body['errors']).to be_present
      end
    end
  end

  describe '#update' do
    let!(:author) { create(:author) }
    let(:params) { { name: 'Updated Author' } }

    context 'when author exists' do
      it 'updates the author' do
        put "/api/v1/admin/authors/#{author.id}", params: { author: params }, headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['author']['name']).to eq(params[:name])
      end
    end

    context 'when author does not exist' do
      it 'returns 404 status code' do
        put '/api/v1/admin/authors/0', params: { author: params }, headers: headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#destroy' do
    let!(:author) { create(:author) }

    context 'when author exists' do
      it 'destroys the author' do
        expect do
          delete "/api/v1/admin/authors/#{author.id}", headers: headers
        end.to change(Author, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end
  end
end
