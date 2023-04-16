# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:normal_user) { create(:user) }
  let(:headers) { admin_user.create_new_auth_token }

  let(:params) do
    {
      email: 'test@test.com',
      password: 'Test123@',
    }
  end

  describe 'When user is not admin' do
    let(:headers) { normal_user.create_new_auth_token }
    let(:user) { create(:user) }

    it 'returns 403 status code' do
      delete "/api/v1/admin/users/#{user.id}", headers: headers
      expect(response.status).to eq(403)
    end
  end

  describe '#index' do
    it 'returns users' do
      get '/api/v1/admin/users', headers: headers
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['users'].size).to eq(2)
      expect(body['meta']).to be_present
    end
  end

  describe '#show' do
    it 'return user' do
      get "/api/v1/admin/users/#{normal_user.id}", headers: headers
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['user']).to be_present
      expect(body['user']['email']).to eq(normal_user.email)
    end
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new user' do
        post '/api/v1/admin/users', params: { user: params }, headers: headers

        expect(response.status).to eq(201)
        body = JSON.parse(response.body)['user']
        expect(SendInBlue::AddContactJob).to have_been_enqueued.with(body['id'])
        expect(body['email']).to eq(params[:email])
        expect(body['role']).to eq('reader')
      end
    end

    context 'with invalid params' do
      it 'returns errors' do
        params[:email] = nil
        post '/api/v1/admin/users', params: { user: params }, headers: headers
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body['errors']).to be_present
      end
    end
  end

  describe '#update' do
    let(:params) { { role: 'admin', admin_request_status: 'accepted' } }

    context 'when user exists' do
      it 'updates the user' do
        put "/api/v1/admin/users/#{normal_user.id}", params: { user: params }, headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)['user']
        expect(body['role']).to eq(params[:role])
        expect(body['admin_request_status']).to eq(params[:admin_request_status])
      end
    end

    context 'when user does not exist' do
      it 'returns 404 status code' do
        put '/api/v1/admin/users/0', params: { user: params }, headers: headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }

    context 'when user exists' do
      it 'destroys the user' do
        delete "/api/v1/admin/users/#{user.id}", headers: headers

        expect(response.status).to eq(204)
      end
    end
  end
end
