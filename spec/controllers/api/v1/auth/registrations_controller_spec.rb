# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :request do
  describe '#create' do
    context 'when user is not requested for admin' do
      let(:params) do
        {
          email: 'test@test.com',
          password: 'Test123@',
          password_confirmation: 'Test123@',
        }
      end

      it 'creates a new user with role reader' do
        post '/auth', params: params
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)['data']
        expect(body['email']).to eq(params[:email])
        expect(body['role']).to eq('reader')
        expect(body['admin_request_status']).to eq('not_required')
      end
    end

    context 'when user requested to become admin' do
      let(:params) do
        {
          email: 'testadmin@test.com',
          password: 'password',
          password_confirmation: 'password',
          is_admin: true,
        }
      end

      it 'creates a new user with role reader and sets requested status' do
        post '/auth', params: params
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)['data']
        expect(body['email']).to eq(params[:email])
        expect(body['role']).to eq('reader')
        expect(body['admin_request_status']).to eq('requested')
      end
    end
  end
end
