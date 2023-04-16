# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { create(:author) }
  describe 'validations' do
    subject { build(:author) }

    it { should validate_presence_of(:name) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a duplicate name' do
      subject.name = author.name
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it { should have_many(:articles).dependent(:destroy) }
    it { should have_many(:topics).through(:articles) }
  end
end
