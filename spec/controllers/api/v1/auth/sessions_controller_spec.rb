# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Auth::SessionsController, type: :request do
  describe '#create' do
    context 'when a user has not confirmed email' do
      let(:user) { create(:user, confirmed_at: nil) }
      let(:params) { { email: user.email, password: user.password } }

      it 'return error' do
        post '/auth/sign_in', params: params
        expect(response).to have_http_status(401)
      end
    end

    context 'when a user has confirmed email' do
      let(:user) { create(:user, confirmed_at: Time.zone.now) }
      let(:params) { { email: user.email, password: user.password } }

      it 'should be able to login' do
        post '/auth/sign_in', params: params
        expect(response).to have_http_status(200)
      end
    end

    context 'when a user has confirmed email and requested for admin' do
      let(:user) { create(:user, confirmed_at: Time.zone.now, admin_request_status: 'requested') }
      let(:params) { { email: user.email, password: user.password } }

      it 'returns error' do
        post '/auth/sign_in', params: params
        expect(response).to have_http_status(401)
      end
    end

    context 'when a user has confirmed email and request status is accepted' do
      let(:user) { create(:user, confirmed_at: Time.zone.now, admin_request_status: 'accepted') }
      let(:params) { { email: user.email, password: user.password } }

      it 'returns success' do
        post '/auth/sign_in', params: params
        expect(response).to have_http_status(200)
      end
    end
  end
end
