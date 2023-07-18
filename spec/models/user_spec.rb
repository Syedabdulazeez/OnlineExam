# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'validations' do
    it 'requires presence of username' do
      user.username = nil
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'requires minimum length of username' do
      user.username = 'ab'
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too short (minimum is 3 characters)')
    end

    it 'requires presence of email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires uniqueness of email' do
      another_user = FactoryBot.build(:user, email: user.email)
      expect(another_user).not_to be_valid
      expect(another_user.errors[:email]).to include('has already been taken')
    end

    it 'validates email format' do
      user.email = 'invalid_email'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('must be a valid email address')
    end

    it 'requires presence of password' do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'requires minimum length of password' do
      user.password = '123'
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 4 characters)')
    end
  end
end
# rubocop:enable Metrics/BlockLength
