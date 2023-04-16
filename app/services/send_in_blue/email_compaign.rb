# frozen_string_literal: true

class SendInBlue::EmailCompaign
  LIST_IDS = [ENV['SIB_LIST_ID']&.to_i].freeze
  LIMIT = 5

  def send_email
    compaign = api_instance.create_email_campaign(compaign_params)
    api_instance.send_email_campaign_now(compaign.id)
  rescue SibApiV3Sdk::ApiError => e
    Rails.logger.error "Exception when sending email compaign #{e.response_body}"
  end

  private

  def api_instance
    SibApiV3Sdk::EmailCampaignsApi.new
  end

  def compaign_params
    {
      name: 'News Articles',
      subject: 'Latest News Articles',
      sender: { name: 'dev-test', email: ENV['SMTP_USERNAME'] },
      recipients: { listIds: LIST_IDS },
      htmlContent: compaign_body,
    }
  end

  def compaign_body
    "<html><body><h1>Latest HeadLines</h1>#{build_articles_headlines_content}</body></html>"
  end

  def latest_articles
    Article.includes(:topic).contain_topics.order(updated_at: :desc).limit(LIMIT)
  end

  def build_articles_headlines_content
    content = '<ul>'
    latest_articles.each do |article|
      content += "<li>#{article.topic&.title}</li>"
    end
    content += '</ul>'
  end
end
