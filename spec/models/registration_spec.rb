# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Registration, type: :model do
  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }
    let(:exam) { FactoryBot.create(:exam) }

    it 'is valid with valid attributes' do
      registration = FactoryBot.build(:registration, user:, exam:)
      expect(registration).to be_valid
    end

    it 'is not valid without a user' do
      registration = FactoryBot.build(:registration, user: nil, exam:)
      expect(registration).not_to be_valid
      expect(registration.errors[:user]).to include('must exist')
    end

    it 'is not valid without an exam' do
      registration = FactoryBot.build(:registration, user:, exam: nil)
      expect(registration).not_to be_valid
      expect(registration.errors[:exam]).to include('must exist')
    end

    it 'is not valid if the same exam is already registered for the user' do
      FactoryBot.create(:registration, user:, exam:)
      registration = FactoryBot.build(:registration, user:, exam:)
      expect(registration).not_to be_valid
      expect(registration.errors[:exam_id]).to include('has alredy been registered')
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

  describe '#started?' do
    it 'returns true if the registration is in progress' do
      registration = FactoryBot.create(:registration, in_progress: true)
      expect(registration.started?).to be true
    end

    it 'returns false if the registration is not in progress' do
      registration = FactoryBot.create(:registration, in_progress: false)
      expect(registration.started?).to be false
    end
  end

  describe '#completed?' do
    it 'returns true if the exam performance exists and marks are obtained' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)
      FactoryBot.create(:exam_performance, user:, exam:, marks_obtained: 80)

      registration = FactoryBot.create(:registration, user:, exam:)

      expect(registration.completed?).to be true
    end

    it 'returns false if the exam performance does not exist or marks are not obtained' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)

      registration = FactoryBot.create(:registration, user:, exam:)

      expect(registration.completed?).to be false
    end
  end
end
# rubocop:enable Metrics/BlockLength
