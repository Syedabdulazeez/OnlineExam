# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExamPerformance, type: :model do
  describe '#generate_report' do
    let(:exam) { create(:exam) }
    let(:exam_performance) { create(:exam_performance, user:, exam:) }
  end
end
