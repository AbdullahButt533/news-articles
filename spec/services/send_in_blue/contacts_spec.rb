# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendInBlue::Contacts do
  let(:sib_api) { instance_double(SibApiV3Sdk::ContactsApi) }
  let(:email) { 'test@test.com' }
  let(:create_contact) { instance_double(SibApiV3Sdk::CreateContact) }

  before do
    allow(SibApiV3Sdk::ContactsApi).to receive(:new).and_return(sib_api)
  end

  describe '#add_contact' do
    it 'adds the contact to SendinBlue' do
      expect(SibApiV3Sdk::CreateContact).to receive(:new).with(email: email).and_return(create_contact)
      expect(create_contact).to receive(:list_ids=).with([ENV['SIB_LIST_ID']&.to_i])

      expect(sib_api).to receive(:create_contact).with(create_contact)

      SendInBlue::Contacts.new.add_contact(email)
    end
  end
end
