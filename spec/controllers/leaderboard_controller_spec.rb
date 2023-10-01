# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeaderboardController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'assigns @performances_summary and @exam_averages' do
      performances_summary = { exam_averages: { exam1: 80, exam2: 75 } }
      allow(ExamPerformance).to receive(:performances_summary).and_return(performances_summary)

      get :index

      expect(assigns(:performances_summary)).to eq(performances_summary)
      expect(assigns(:exam_averages).to_a).to eq(performances_summary[:exam_averages].to_a)
    end
  end
end
