# frozen_string_literal: true

class Api::V1::Admin::ArticlesController < Api::V1::Admin::ApplicationController
  before_action :set_article, only: [:update, :destroy]

  def create
    article = Article.new(article_params)
    respond_with article, serializer: Api::V1::ArticleSerializer if article.save!
  end

  def update
    respond_with @article, serializer: Api::V1::ArticleSerializer if @article.update!(article_params)
  end

  def destroy
    @article.destroy!
  end

  private

  def set_article
    @article = Article.includes(Article.eager_load_options).find(params[:id])
  end

  def article_params
    params.require(:article).permit(:description, :url, :url_to_image, :content, :published_at, :topic_id, :author_id, source: {})
  end
end
