# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topic) { create(:topic) }

  describe 'validations' do
    subject { build(:topic) }

    it { should validate_presence_of(:title) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate name' do
      subject.title = topic.title
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:articles).dependent(:destroy) }
    it { should have_many(:authors).through(:articles) }
  end
end
