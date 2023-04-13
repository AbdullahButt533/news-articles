# frozen_string_literal: true

class Api::V1::ArticlesController < Api::V1::ApplicationController
  before_action :set_article, only: :show

  def index
    articles = Article.includes(Article.eager_load_options).page(page).per(per_page)
    respond_with articles, meta: build_meta(articles)
  end

  def show
    respond_with @article
  end

  private

  def set_article
    @article = Article.includes(Article.eager_load_options).find(params[:id])
  end
end
