# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendInBlue::EmailCompaign do
  describe '#send_email' do
    let(:api_instance) { instance_double(SibApiV3Sdk::EmailCampaignsApi) }
    let(:compaign) { double(id: 1) }
    let(:compaign_body) { '<html><body><h1>Latest HeadLines</h1><ul><li>Test 1</li><li>Test 2</li></ul></body></html>' }
    let(:latest_articles) { [double(topic: double(title: 'Test 1')), double(topic: double(title: 'Test 2'))] }
    let(:params) do
      {
        name: 'Test',
        subject: 'Test Articles',
        sender: { name: 'dev-test', email: 'test@test.com' },
        recipients: { listIds: [ENV['SIB_LIST_ID']&.to_i] },
        htmlContent: compaign_body,
      }
    end

    before do
      allow(SibApiV3Sdk::EmailCampaignsApi).to receive(:new).and_return(api_instance)
      allow(subject).to receive(:compaign_body).and_return(compaign_body)
      allow(subject).to receive(:latest_articles).and_return(latest_articles)
      allow(api_instance).to receive(:create_email_campaign).and_return(compaign)
      allow(api_instance).to receive(:send_email_campaign_now)
      allow(subject).to receive(:compaign_params).and_return(params)
    end

    it 'sends the email campaign' do
      expect(api_instance).to receive(:create_email_campaign).with(params).and_return(compaign)

      expect(api_instance).to receive(:send_email_campaign_now).with(compaign.id)

      subject.send_email
    end
  end
end
