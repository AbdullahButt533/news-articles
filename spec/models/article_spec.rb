# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { create(:article) }

  describe 'validations' do
    subject { build(:article) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a url' do
      subject.url = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate url' do
      subject.url = article.url
      expect(subject).not_to be_valid
    end

    it 'is not valid with a description exceeding maximum length' do
      subject.description = 'x' * 501
      expect(subject).not_to be_valid
    end

    it 'is not valid with content exceeding maximum length' do
      subject.content = 'y' * 501
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:author).optional }
    it { should belong_to(:topic).optional }
  end

  describe 'scopes' do
    let!(:article_with_topic) { create(:article) }
    let!(:article_without_topic) { create(:article, topic: nil) }

    describe '.contain_topics' do
      it 'returns articles with a topic' do
        expect(Article.contain_topics).to include(article_with_topic)
      end

      it 'does not return articles without a topic' do
        expect(Article.contain_topics).not_to include(article_without_topic)
      end
    end
  end

  describe 'class methods' do
    describe '.eager_load_options' do
      it 'returns an array of association names to eager load' do
        expect(Article.eager_load_options).to match_array([:author, :topic])
      end
    end
  end
end
