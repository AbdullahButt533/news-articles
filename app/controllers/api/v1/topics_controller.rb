# frozen_string_literal: true

class Api::V1::TopicsController < Api::V1::ApplicationController
  before_action :set_topic, only: :show

  def index
    topics = Topic.page(page).per(per_page)
    respond_with topics, meta: build_meta(topics)
  end

  def show
    respond_with @topic
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end
end
