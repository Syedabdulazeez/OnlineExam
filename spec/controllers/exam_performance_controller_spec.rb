# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe ExamPerformancesController, type: :controller do
  let(:user) { create(:user) }

  let(:exam_performance) { create(:exam_performance, user:) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the requested exam performance to @exam_performance' do
      get :show, params: { id: exam_performance.id }
      expect(assigns(:exam_performance)).to eq(exam_performance)
    end

    it 'renders the show template' do
      get :show, params: { id: exam_performance.id }
      expect(response).to render_template('show')
    end

    it 'requires user authentication' do
      allow(controller).to receive(:current_user).and_return(nil)
      get :show, params: { id: exam_performance.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST #generate_report' do
    it 'generates a performance report and redirects to the leaderboard' do
      allow(exam_performance).to receive(:generate_report)

      post :generate_report, params: { id: exam_performance.id }

      expect(flash[:success]).to be_present
      expect(response).to redirect_to(leaderboard_index_path(user))
    end

    it 'requires user authentication' do
      allow(controller).to receive(:current_user).and_return(nil)
      post :generate_report, params: { id: exam_performance.id }
      expect(response).to redirect_to(root_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
