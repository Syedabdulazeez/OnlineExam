# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Department, type: :model do
  let(:department) { Department.new(department_name: 'Computer Science') }

  describe 'validations' do
    it 'validates presence of department_name' do
      department.department_name = nil
      expect(department).not_to be_valid
      expect(department.errors[:department_name]).to include("can't be blank")
    end

    it 'validates minimum length of department_name' do
      department.department_name = 'ab'
      expect(department).not_to be_valid
      expect(department.errors[:department_name]).to include('must contain at least 3 letters')
    end

    it 'is valid with a valid department_name' do
      expect(department).to be_valid
    end
  end
end
