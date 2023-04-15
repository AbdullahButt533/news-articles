# frozen_string_literal: true

class SendInBlue::Contacts
  attr_accessor :list_id

  def initialize
    @list_id = ENV['SIB_LIST_ID']&.to_i
  end

  def add_contact(email)
    contact = SibApiV3Sdk::CreateContact.new(email: email)
    contact.list_ids = [list_id]

    contacts_api.create_contact(contact)
  rescue SibApiV3Sdk::ApiError => e
    Rails.logger.error "Error adding #{email} to SendinBlue: #{e.response_body}"
  end

  private

  def contacts_api
    SibApiV3Sdk::ContactsApi.new
  end
end
