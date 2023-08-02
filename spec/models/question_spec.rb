# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Question, type: :model do
  describe 'validations' do
    let(:exam) { FactoryBot.create(:exam) }

    it 'is valid with valid attributes' do
      question = FactoryBot.build(:question, exam:)
      expect(question.valid?).to be true
    end

    it 'is not valid without an exam' do
      question = FactoryBot.build(:question, exam: nil)
      expect(question.valid?).to be false
      expect(question.errors[:exam]).to include('must exist')
    end

    it 'is not valid without a question_text' do
      question = FactoryBot.build(:question, question_text: nil, exam:)
      expect(question.valid?).to be false
      expect(question.errors[:question_text]).to include("can't be blank")
    end

    it 'is not valid without answer1' do
      question = FactoryBot.build(:question, answer1: nil, exam:)
      expect(question.valid?).to be false
      expect(question.errors[:answer1]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to an exam' do
      association = described_class.reflect_on_association(:exam)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'should belong to an exam' do
      exam_association = Question.reflect_on_association(:exam)
      expect(exam_association.macro).to eq(:belongs_to)
    end
  end
end
# rubocop:enable Metrics/BlockLength
