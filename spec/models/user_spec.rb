# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(reader: 0, admin: 1) }
    it { should define_enum_for(:admin_request_status).with_values(not_required: 0, requested: 1, accepted: 2, rejected: 3) }
  end

  describe 'callbacks' do
    it 'should add user to Sendinblue list after create' do
      user = create(:user)
      expect(SendInBlue::AddContactJob).to have_been_enqueued.with(user.id)
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }

    describe '#active_for_authentication?' do
      context 'when user is active' do
        it 'returns true' do
          expect(user.active_for_authentication?).to eq(true)
        end
      end

      context 'when user is not active' do
        before { user.update(admin_request_status: :requested, role: 'admin') }

        it 'returns false' do
          expect(user.active_for_authentication?).to eq(false)
        end
      end
    end
  end
end
