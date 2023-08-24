# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe ExamPerformance, type: :model do
  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }
    let(:exam) { FactoryBot.create(:exam) }

    it 'is valid with valid attributes' do
      exam_performance = FactoryBot.build(:exam_performance, user:, exam:)
      expect(exam_performance).to be_valid
    end

    it 'is not valid without a user' do
      exam_performance = FactoryBot.build(:exam_performance, user: nil, exam:)
      expect(exam_performance).not_to be_valid
      expect(exam_performance.errors[:user]).to include('must exist')
    end

    it 'is not valid without an exam' do
      exam_performance = FactoryBot.build(:exam_performance, user:, exam: nil)
      expect(exam_performance).not_to be_valid
      expect(exam_performance.errors[:exam]).to include('must exist')
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to an exam' do
      association = described_class.reflect_on_association(:exam)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe '.overall_rank' do
    it 'returns the overall rank of the user based on average marks obtained in exams' do
      user = FactoryBot.create(:user)
      exam1 = FactoryBot.create(:exam)
      exam2 = FactoryBot.create(:exam)
      FactoryBot.create(:exam_performance, user:, exam: exam1, marks_obtained: 80)
      FactoryBot.create(:exam_performance, user:, exam: exam2, marks_obtained: 90)

      overall_rank = described_class.overall_rank(user)

      expect(overall_rank).to eq(0)
    end
  end

  describe '.college_rank' do
    it 'returns the college rank of the user based on average marks obtained in exams within the same college' do
      college = 'Sample College'
      user = FactoryBot.create(:user, college:)
      user2 = FactoryBot.create(:user, college:)
      exam1 = FactoryBot.create(:exam)
      exam2 = FactoryBot.create(:exam)
      FactoryBot.create(:exam_performance, user:, exam: exam1, marks_obtained: 80)
      FactoryBot.create(:exam_performance, user: user2, exam: exam2, marks_obtained: 90)

      college_rank = ExamPerformance.college_rank(user)

      expect(college_rank).to eq(nil)
    end
  end

  describe '.performances_summary' do
    it 'returns a hash containing various performance metrics for the user' do
      user = FactoryBot.create(:user)
      exam1 = FactoryBot.create(:exam, exam_name: 'Math Exam')
      exam2 = FactoryBot.create(:exam, exam_name: 'Science Exam')
      exam_performance1 = FactoryBot.create(:exam_performance, user:, exam: exam1, marks_obtained: 80)
      exam_performance2 = FactoryBot.create(:exam_performance, user:, exam: exam2, marks_obtained: 90)

      performances_summary = ExamPerformance.performances_summary(user)

      expect(performances_summary[:exam_ids_attended]).to contain_exactly(exam1.id, exam2.id)
      expect(performances_summary[:exam_averages][exam1.id]).to eq(80)
      expect(performances_summary[:exam_averages][exam2.id]).to eq(90)
      expect(performances_summary[:highest_marks][exam1.id]).to eq(80)
      expect(performances_summary[:highest_marks][exam2.id]).to eq(90)
      expect(performances_summary[:exam_performances].pluck(:id)).to contain_exactly(exam_performance1.id,
                                                                                     exam_performance2.id)
      expect(performances_summary[:department_performance]).to eq({ 'Sample Department' => 90 })
      expect(performances_summary[:subject_performance]).to eq({ 'Subject 8' => 80, 'Subject 9' => 90 })
    end
  end
end
# rubocop:enable Metrics/BlockLength
