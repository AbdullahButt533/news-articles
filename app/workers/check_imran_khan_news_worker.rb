# frozen_string_literal: true

require 'sidekiq-scheduler'

class CheckImranKhanNewsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    NewsArticles::BatchProcessor.new(build_query_params, Article::EVERYTHING_PATH).call
  end

  private

  def build_query_params
    {
      q: 'Imran Khan',
      from: 2.days.ago.strftime('%Y-%m-%d'),
      sortBy: 'publishedAt',
    }
  end
end
