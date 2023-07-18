# frozen_string_literal: true

require 'rails_helper'

# spec/models/registration_spec.rb
RSpec.describe Registration, type: :model do
  describe 'validations' do
    it 'validates uniqueness of exam_id scoped to user_id' do
      user = FactoryBot.create(:user)
      exam = FactoryBot.create(:exam)
      FactoryBot.create(:registration, user:, exam:)

      registration = FactoryBot.build(:registration, user:, exam:)
      expect(registration).not_to be_valid
    end
  end
end
