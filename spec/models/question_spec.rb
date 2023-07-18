# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Question, type: :model do
  describe 'validations' do
    it 'validates presence of question_text' do
      question = Question.new
      question.valid?
      expect(question.errors[:question_text]).to include("can't be blank")
    end

    it 'validates minimum length of question_text' do
      question = Question.new(question_text: 'ABC')
      question.valid?
      expect(question.errors[:question_text]).to include('must contain at least 5 letters')
    end

    it 'validates presence of answer1' do
      question = Question.new
      question.valid?
      expect(question.errors[:answer1]).to include("can't be blank")
    end

    it 'validates presence of answer2' do
      question = Question.new
      question.valid?
      expect(question.errors[:answer2]).to include("can't be blank")
    end

    it 'validates presence of answer3' do
      question = Question.new
      question.valid?
      expect(question.errors[:answer3]).to include("can't be blank")
    end

    it 'validates presence of answer4' do
      question = Question.new
      question.valid?
      expect(question.errors[:answer4]).to include("can't be blank")
    end

    it 'validates presence of correct_answer' do
      question = Question.new
      question.valid?
      expect(question.errors[:correct_answer]).to include("can't be blank")
    end
  end
end
# rubocop:enable Metrics/BlockLength
