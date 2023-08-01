# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
      user = FactoryBot.build(:user, username: nil)
      expect(user).not_to be_valid
      expect(user.errors[:username]).to be_present
    end

    it 'is not valid without a unique username' do
      FactoryBot.create(:user, username: 'existinguser')
      user = FactoryBot.build(:user, username: 'existinguser')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to be_present
    end

    it 'is not valid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'is not valid without a unique email' do
      FactoryBot.create(:user, email: 'existinguser@example.com')
      user = FactoryBot.build(:user, email: 'existinguser@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'is not valid with an invalid email format' do
      user = FactoryBot.build(:user, email: 'invalid_email_format')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end
  end

  describe 'associations' do
    it 'has many exam_performances' do
      association = described_class.reflect_on_association(:exam_performances)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many registrations' do
      association = described_class.reflect_on_association(:registrations)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many exams through registrations' do
      association = described_class.reflect_on_association(:exams)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:registrations)
    end
  end

  describe '#generate_magic_link_token' do
    it 'generates a magic link token and saves it' do
      user = FactoryBot.create(:user)
      expect(SecureRandom).to receive(:urlsafe_base64).and_return('random_token')

      user.generate_magic_link_token

      expect(user.magic_link_token).to eq('random_token')
      expect(user).to be_persisted
    end
  end

  describe '#exam_registered?' do
    it 'returns true if the user is registered for the exam' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)
      FactoryBot.create(:registration, user:, exam:)

      expect(user.exam_registered?(exam)).to eq(true)
    end

    it 'returns false if the user is not registered for the exam' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)

      expect(user.exam_registered?(exam)).to eq(false)
    end
  end

  describe '#exam_in_progress?' do
    it 'returns true if the user has the exam in progress' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)
      FactoryBot.create(:registration, user:, exam:, in_progress: true)

      expect(user.exam_in_progress?(exam)).to eq(true)
    end

    it 'returns false if the user does not have the exam in progress' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)
      FactoryBot.create(:registration, user:, exam:, in_progress: false)

      expect(user.exam_in_progress?(exam)).to eq(false)
    end
  end
end

# rubocop:enable Metrics/BlockLength
