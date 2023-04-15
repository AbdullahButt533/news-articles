# frozen_string_literal: true

class NewsArticles::BatchProcessor
  BATCH_SIZE = 100
  attr_accessor :params, :path

  def initialize(params, path)
    @params = params
    @path = path
  end

  def call
    fetch_and_persist_articles
  end

  private

  def fetch_and_persist_articles
    params[:pageSize] ||= BATCH_SIZE
    @articles = []
    page = 1
    loop do
      params[:page] = page
      data = fetch_data
      result = data && JSON.parse(data.body)['articles']

      break if result.blank?

      @articles += result
      page += 1
    end

    parsed_articles = parse_data

    return if parsed_articles.empty?

    Article.upsert_all(parsed_articles, unique_by: [:url])
    SendInBlue::SendEmailToContacts.perform_later
  end

  def news_api
    NewsArticles::Search.new(params)
  end

  def fetch_data
    return unless [Article::EVERYTHING_PATH, Article::TOP_HEADLINES_PATH].include? path

    path == Article::EVERYTHING_PATH ? news_api.everything : news_api.top_headlines
  end

  def parse_data
    @articles.map do |article|
      title = article['title']
      author = article['author']

      {
        topic_id: title.present? ? Topic.find_or_create_by(title: title).id : nil,
        author_id: author.present? ? Author.find_or_create_by(name: author).id : nil,
        description: article['description'],
        url: article['url'],
        published_at: DateTime.parse(article['publishedAt']),
        content: article['content'],
        url_to_image: article['urlToImage'],
        source: article['source'],
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end
  end
end
