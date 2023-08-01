# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Department, type: :model do
  describe 'validations' do
    context 'when department_name is present and has at least 3 letters' do
      it 'is valid' do
        department = build(:department, department_name: 'Math')
        expect(department).to be_valid
      end
    end

    context 'when department_name is not present' do
      it 'is invalid' do
        department = build(:department, department_name: nil)
        expect(department).not_to be_valid
        expect(department.errors[:department_name]).to include("can't be blank")
      end
    end

    context 'when department_name has less than 3 letters' do
      it 'is invalid' do
        department = build(:department, department_name: 'IT')
        expect(department).not_to be_valid
        expect(department.errors[:department_name]).to include('must contain at least 3 letters')
      end
    end
  end

  describe 'associations' do
    it 'has many subjects' do
      association = described_class.reflect_on_association(:subjects)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys associated subjects on department destroy' do
      department = create(:department)
      create(:subject, department:)
      expect { department.destroy }.to change { Subject.count }.by(-1)
    end

    it 'has many exams through subjects' do
      association = described_class.reflect_on_association(:exams)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:subjects)
    end

    it 'has many professors' do
      association = described_class.reflect_on_association(:professors)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys associated professors on department destroy' do
      department = create(:department)
      create(:professor, department:)
      expect { department.destroy }.to change { Professor.count }.by(-1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
