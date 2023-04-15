# frozen_string_literal: true

class SendInBlue::AddContactJob < ApplicationJob
  sidekiq_options queue: 'default'

  def perform(user_id)
    return unless user_id

    user = User.find(user_id)
    sib_contacts = SendInBlue::Contacts.new
    sib_contacts.add_contact(user.email)
  end
end
