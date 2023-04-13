# frozen_string_literal: true

class NewsArticles::ParamsBuilder
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def build_options
    build_search_options.reject { |_key, value| value.blank? }
  end

  private

  def build_search_options
    {
      q: params[:q],
      searchIn: params[:searchIn],
      sources: params[:sources],
      domains: params[:domains],
      excludeDomains: params[:excludeDomains],
      from: params[:from],
      to: params[:to],
      language: params[:language],
      sortBy: params[:sortBy],
      pageSize: params[:pageSize],
      page: params[:page],
    }
  end
end
