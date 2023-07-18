# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe 'validations' do
    it 'does not have any validations by default' do
      expect(ApplicationRecord.validators).to be_empty
    end
  end
end
