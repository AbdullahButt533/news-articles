# frozen_string_literal: true

class NewsArticles::Search
  EVERYTHING_PATH = 'everything'

  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def live_articles
    make_request(build_url(EVERYTHING_PATH))
  end

  private

  def api_key
    ENV['NEWS_API_KEY']
  end

  def path(name)
    "https://newsapi.org/v2/#{name}?"
  end

  def build_query_params
    query_params = ''
    params.each do |key, value|
      query_params += "#{key}=#{value}&"
    end
    query_params
  end

  def build_url(path_name)
    path(path_name) + build_query_params + "apiKey=#{api_key}"
  end

  def make_request(url)
    uri = URI(url)

    request = Net::HTTP::Get.new(uri.to_s)
    request['Content-Type'] = 'application/json'

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.request(request)
  end
end
