# frozen_string_literal: true

class Api::V1::Admin::TopicsController < Api::V1::Admin::ApplicationController
  before_action :set_topic, only: [:update, :destroy]

  def create
    topic = Topic.new(topic_params)
    respond_with topic, serializer: Api::V1::TopicSerializer if topic.save!
  end

  def update
    respond_with @topic, serializer: Api::V1::TopicSerializer if @topic.update!(topic_params)
  end

  def destroy
    @topic.destroy!
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title)
  end
end
