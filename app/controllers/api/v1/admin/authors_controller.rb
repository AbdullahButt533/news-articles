# frozen_string_literal: true

class Api::V1::Admin::AuthorsController < Api::V1::Admin::ApplicationController
  before_action :set_author, only: [:update, :destroy]

  def create
    author = Author.new(author_params)
    respond_with author, serializer: Api::V1::AuthorSerializer if author.save!
  end

  def update
    respond_with @author, serializer: Api::V1::AuthorSerializer if @author.update!(author_params)
  end

  def destroy
    @author.destroy!
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name)
  end
end
