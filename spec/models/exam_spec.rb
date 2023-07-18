# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Exam, type: :model do
  describe 'validations' do
    it 'validates presence of exam_name' do
      exam = Exam.new
      exam.valid?
      expect(exam.errors[:exam_name]).to include("can't be blank")
    end

    it 'validates minimum length of exam_name' do
      exam = Exam.new(exam_name: 'AB')
      exam.valid?
      expect(exam.errors[:exam_name]).to include('must contain at least 3 letters')
    end

    it 'validates presence of start_time' do
      exam = Exam.new
      exam.valid?
      expect(exam.errors[:start_time]).to include("can't be blank")
    end
  end
end
