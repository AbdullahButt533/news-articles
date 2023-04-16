# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsArticles::Search do
  let(:success_body) { { status: 'ok', articles: [] } }
  let(:error_body) { { status: 'error', message: 'invalid' } }
  describe '#everything' do
    let(:params) { { q: 'test', page: 1, pageSize: 5 } }
    context 'when the API request is successful' do
      before do
        stub_request(:get, %r{newsapi\.org/v2/everything})
          .to_return(status: 200, body: success_body.to_json)
      end

      it 'returns a successful response' do
        result = described_class.new(params).everything
        expect(result.code).to eq('200')
        expect(JSON.parse(result.body)['articles']).to eq(success_body[:articles])
      end
    end

    context 'when the API request is unsuccessful' do
      before do
        stub_request(:get, %r{newsapi\.org/v2/everything})
          .to_return(status: 400, body: error_body.to_json)
      end

      it 'returns an error response' do
        result = described_class.new.everything
        expect(result.code).to eq('400')
      end
    end
  end

  describe '#top_headlines' do
    let(:params) { { country: 'us', category: 'business' } }
    context 'when the API request is successful' do
      before do
        stub_request(:get, %r{newsapi\.org/v2/top-headlines})
          .to_return(status: 200, body: success_body.to_json)
      end

      it 'returns a successful response' do
        result = described_class.new(params).top_headlines
        expect(result.code).to eq('200')
        expect(JSON.parse(result.body)['articles']).to eq(success_body[:articles])
      end
    end

    context 'when the API request is unsuccessful' do
      before do
        stub_request(:get, %r{newsapi\.org/v2/top-headlines})
          .to_return(status: 400, body: error_body.to_json)
      end

      it 'returns an error response' do
        result = described_class.new.top_headlines
        expect(result.code).to eq('400')
      end
    end
  end
end
