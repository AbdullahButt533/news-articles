# frozen_string_literal: true

class Api::V1::AuthorsController < Api::V1::ApplicationController
  before_action :set_author, only: :show

  def index
    authors = Author.page(page).per(per_page)
    respond_with authors, meta: build_meta(authors)
  end

  def show
    respond_with @author
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end
end
