# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  describe 'when user is authenticated' do
    let!(:user) { create(:user) }
    let!(:articles) { create_list(:article, 3) }
    let(:headers) { user.create_new_auth_token }

    context '#index' do
      it 'returns articles' do
        get '/api/v1/articles', headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['articles'].size).to eq(3)
        expect(body['meta']).to be_present
      end
    end

    context '#live_articles_search' do
      let(:params) { { q: 'test' } }
      let(:url) { "https://newsapi.org/v2/everything?q=#{params[:q]}&apiKey=#{ENV['NEWS_API_KEY']}" }
      let(:body) { { code: 200, articles: [] } }
      it 'return article' do
        # Stub the HTTP request made by `make_request` method
        stub_request(:get, url).to_return(status: 200, body: body.to_json, headers: {})

        get '/api/v1/articles/live_articles_search', params: params, headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['articles']).to eql([])
      end
    end

    context '#show' do
      it 'return article' do
        article = articles.first
        get "/api/v1/articles/#{article.id}", headers: headers
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['article']).to be_present
        expect(body['article']['url']).to eq(article.url)
      end
    end
  end

  describe 'when user is not authenticated' do
    it 'returns 401 status code' do
      get '/api/v1/articles'
      expect(response.status).to eq(401)
    end
  end
end
