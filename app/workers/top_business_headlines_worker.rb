# frozen_string_literal: true

require 'sidekiq-scheduler'

class TopBusinessHeadlinesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    NewsArticles::BatchProcessor.new(build_query_params, Article::TOP_HEADLINES_PATH).call
  end

  private

  def build_query_params
    {
      country: 'us',
      category: 'business',
      from: 3.hours.ago.strftime('%Y-%m-%d'),
      sortBy: 'publishedAt',
    }
  end
end
