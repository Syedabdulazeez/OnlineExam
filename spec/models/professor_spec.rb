# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      professor = Professor.new
      professor.valid?
      expect(professor.errors[:name]).to include("can't be blank")
    end

    it 'validates minimum length of name' do
      professor = Professor.new(name: 'AB')
      professor.valid?
      expect(professor.errors[:name]).to include('must contain at least 3 letters')
    end

    it 'validates presence of summary' do
      professor = Professor.new
      professor.valid?
      expect(professor.errors[:summary]).to include("can't be blank")
    end

    it 'validates minimum length of summary' do
      professor = Professor.new(summary: 'ABC')
      professor.valid?
      expect(professor.errors[:summary]).to include('must contain at least 5 letters')
    end
  end
end
