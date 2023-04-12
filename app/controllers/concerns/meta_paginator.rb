# frozen_string_literal: true

module MetaPaginator
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def build_meta(collection)
    {
      prev_page: collection.prev_page,
      current_page: collection.current_page,
      next_page: collection.next_page,
      total_count: collection.total_count,
      total_pages: collection.total_pages,
    }
  end

  def page
    params[:page] || DEFAULT_PAGE
  end

  def per_page
    params[:per_page] || DEFAULT_PER_PAGE
  end
end
