# frozen_string_literal: true

require 'rails_helper'
RSpec.describe NewsArticles::BatchProcessor do
  describe '#call' do
    let(:params) { { q: 'test' } }
    let(:path) { Article::EVERYTHING_PATH }
    let(:batch_processor) { described_class.new(params, path) }
    let(:response) do
      instance_double(Net::HTTPSuccess,
                      body: { articles: [{ url: 'http://test.com', content: 'test content' }] }.to_json)
    end

    before do
      allow(batch_processor).to receive(:fetch_data).and_return(response)
    end

    context 'when data is fetched successfully' do
      it 'fetches and persists articles' do
        batch_processor.call

        expect(SendInBlue::SendEmailToContacts).to have_been_enqueued
      end
    end
  end
end
