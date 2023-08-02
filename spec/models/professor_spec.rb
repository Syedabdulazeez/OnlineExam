# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Professor, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      department = FactoryBot.create(:department)
      professor = FactoryBot.build(:professor, department:)
      expect(professor).to be_valid
    end

    it 'is invalid without a department' do
      professor = FactoryBot.build(:professor, department: nil)
      expect(professor).not_to be_valid
      expect(professor.errors[:department_id]).to include('Please select subject')
    end

    it 'is invalid without a name' do
      professor = FactoryBot.build(:professor, name: nil)
      expect(professor).not_to be_valid
      expect(professor.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a name containing less than 3 letters' do
      professor = FactoryBot.build(:professor, name: 'Dr')
      expect(professor).not_to be_valid
      expect(professor.errors[:name]).to include('must contain at least 3 letters')
    end

    it 'is invalid without a summary' do
      professor = FactoryBot.build(:professor, summary: nil)
      expect(professor).not_to be_valid
      expect(professor.errors[:summary]).to include("can't be blank")
    end

    it 'is invalid with a summary containing less than 5 letters' do
      professor = FactoryBot.build(:professor, summary: 'Prof')
      expect(professor).not_to be_valid
      expect(professor.errors[:summary]).to include('must contain at least 5 letters')
    end
  end

  describe 'associations' do
    it 'belongs to a department' do
      association = described_class.reflect_on_association(:department)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has one attached profile picture' do
      association = described_class.reflect_on_association(:profile_picture)
      expect(association)
      expect(association.macro).to eq(:has_one_attached) if association
    end

    it 'is valid with a valid department association' do
      department = FactoryBot.create(:department)
      professor = FactoryBot.build(:professor, department:)
      expect(professor).to be_valid
    end

    it 'is invalid without a department association' do
      professor = FactoryBot.build(:professor, department: nil)
      expect(professor).not_to be_valid
      expect(professor.errors[:department_id]).to include('Please select subject')
    end
  end
end
# rubocop:enable Metrics/BlockLength
