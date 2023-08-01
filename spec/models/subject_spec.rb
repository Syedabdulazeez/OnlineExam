# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Subject, type: :model do
  describe 'validations' do
    let(:department) { FactoryBot.create(:department) } # Create a valid Department object

    it 'is valid with valid attributes' do
      subject = FactoryBot.build(:subject, department:)
      expect(subject).to be_valid
    end

    it 'is not valid without a department_id' do
      subject = FactoryBot.build(:subject, department_id: nil)
      expect(subject).not_to be_valid
      expect(subject.errors[:department_id]).to be_present
    end

    it 'is not valid without a subject_name' do
      subject = FactoryBot.build(:subject, subject_name: nil, department:)
      expect(subject).not_to be_valid
      expect(subject.errors[:subject_name]).to be_present
    end

    it 'is not valid with a subject_name containing less than 3 letters' do
      subject = FactoryBot.build(:subject, subject_name: 'AB', department:)
      expect(subject).not_to be_valid
      expect(subject.errors[:subject_name]).to be_present
    end
  end

  describe 'associations' do
    let(:department) { FactoryBot.create(:department) }

    it 'belongs to a department' do
      subject = FactoryBot.create(:subject, department:)
      expect(subject.department).to eq(department)
    end

    it 'has many exams with dependent destroy' do
      subject = FactoryBot.create(:subject, department:)
      exam1 = FactoryBot.create(:exam, subject:)
      exam2 = FactoryBot.create(:exam, subject:)

      expect(subject.exams).to include(exam1, exam2)

      subject.destroy
      expect(Exam.where(id: exam1.id)).not_to exist
      expect(Exam.where(id: exam2.id)).not_to exist
    end
  end
end
# rubocop:enable Metrics/BlockLength
