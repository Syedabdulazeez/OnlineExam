# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Exam, type: :model do
  describe 'validations' do
    let(:subject) { FactoryBot.create(:subject) }

    it 'is valid with valid attributes' do
      exam = FactoryBot.build(:exam, subject:)
      expect(exam).to be_valid
    end

    it 'is not valid without an exam_name' do
      exam = FactoryBot.build(:exam, exam_name: nil, subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:exam_name]).to be_present
    end

    it 'is not valid with an exam_name containing less than 3 letters' do
      exam = FactoryBot.build(:exam, exam_name: 'AB', subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:exam_name]).to be_present
    end

    it 'is not valid without a subject' do
      exam = FactoryBot.build(:exam, subject: nil)
      expect(exam).not_to be_valid
      expect(exam.errors[:subject]).to be_present
    end

    it 'is not valid without a start_time' do
      exam = FactoryBot.build(:exam, start_time: nil, subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:start_time]).to be_present
    end

    it 'is not valid if start_time is in the past' do
      exam = FactoryBot.build(:exam, start_time: 1.day.ago, subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:start_time]).to be_present
    end

    it 'is not valid without a duration' do
      exam = FactoryBot.build(:exam, duration: nil, subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:duration]).to be_present
    end

    it 'is not valid if duration is not greater than zero' do
      exam = FactoryBot.build(:exam, duration: -1, subject:)
      expect(exam).not_to be_valid
      expect(exam.errors[:duration]).to be_present
    end
  end

  describe 'associations' do
    it 'belongs to a subject' do
      association = described_class.reflect_on_association(:subject)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many registrations' do
      association = described_class.reflect_on_association(:registrations)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many users through registrations' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:registrations)
    end

    it 'has many questions' do
      association = described_class.reflect_on_association(:questions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many exam_performances' do
      association = described_class.reflect_on_association(:exam_performances)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
  describe 'model methods' do
    let(:subject) { FactoryBot.create(:subject) }

    describe '#start_time_must_be_future' do
      it 'is valid when start_time is in the future' do
        exam = FactoryBot.build(:exam, start_time: DateTime.now + 1.day, subject:)
        expect(exam).to be_valid
      end

      it 'is not valid when start_time is in the past' do
        exam = FactoryBot.build(:exam, start_time: DateTime.now - 1.day, subject:)
        expect(exam).not_to be_valid
        expect(exam.errors[:start_time]).to be_present
      end

      it 'is not valid when start_time is nil' do
        exam = FactoryBot.build(:exam, start_time: nil, subject:)
        expect(exam).not_to be_valid
        expect(exam.errors[:start_time]).to be_present
      end
    end

    describe 'shuffled_questions' do
      it 'returns an array of shuffled questions' do
        exam = FactoryBot.create(:exam, subject:)
        question1 = FactoryBot.create(:question, exam:)
        question2 = FactoryBot.create(:question, exam:)
        question3 = FactoryBot.create(:question, exam:)

        shuffled_questions = exam.shuffled_questions

        expect(shuffled_questions).to contain_exactly(question1, question2, question3)
      end
    end

    describe '#calculate_score' do
      it 'returns the correct score for user answers' do
        exam = FactoryBot.create(:exam, subject:)
        FactoryBot.create(:question, exam:, correct_answer: 2)
        FactoryBot.create(:question, exam:, correct_answer: 3)
        FactoryBot.create(:question, exam:, correct_answer: 1)

        user_answers = {
          '0' => '1',
          '1' => '3',
          '2' => '1'
        }

        score = exam.calculate_score(user_answers)

        expect(score).to eq(2 / 3.0 * 100)
      end
    end

    describe '#create_exam_performance' do
      it 'creates a new exam performance record' do
        exam = FactoryBot.create(:exam, subject:)
        user = FactoryBot.create(:user)

        expect do
          exam.create_exam_performance(user.id, 75)
        end.to change(ExamPerformance, :count).by(1)

        performance = ExamPerformance.last
        expect(performance.exam).to eq(exam)
        expect(performance.user).to eq(user)
        expect(performance.marks_obtained).to eq(75)
      end
    end

    describe '#demo_exam' do
      it 'returns the demo exam for the subject' do
        exam = FactoryBot.create(:exam, subject:, is_demo: true)
        expect(Exam).to receive(:find_by).with(subject_id: subject.id, is_demo: true).and_return(exam)

        demo_exam = exam.demo_exam

        expect(demo_exam).to eq(exam)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
