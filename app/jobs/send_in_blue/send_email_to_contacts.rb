# frozen_string_literal: true

class SendInBlue::SendEmailToContacts < ApplicationJob
  sidekiq_options queue: 'default'

  def perform
    SendInBlue::EmailCompaign.new.send_email
  end
end
