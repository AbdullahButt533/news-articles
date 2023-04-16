# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthorsController, type: :request do
  describe 'when user is authenticated' do
    let!(:user) { create(:user) }
    let!(:authors) { create_list(:author, 3) }
    let(:headers) { user.create_new_auth_token }

    context '#index' do
      it 'returns authors' do
        get '/api/v1/authors', headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['authors'].size).to eq(3)
        expect(body['meta']).to be_present
      end
    end

    context '#show' do
      it 'return author' do
        author = authors.first
        get "/api/v1/authors/#{author.id}", headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['author']).to be_present
        expect(body['author']['name']).to eq(author.name)
      end
    end
  end

  describe 'when user is not authenticated' do
    it 'returns 401 status code' do
      get '/api/v1/authors'
      expect(response.status).to eq(401)
    end
  end
end
