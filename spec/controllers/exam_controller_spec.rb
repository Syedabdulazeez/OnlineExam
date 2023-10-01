# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe ExamsController, type: :controller do
  let(:user) { create(:user) }

  let(:exam) { create(:exam) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #conduct' do
    it 'redirects to the exam show page' do
      get :conduct, params: { id: exam.id }
      expect(response.status).to eq(200)
    end

    it 'requires user authentication' do
      allow(controller).to receive(:current_user).and_return(nil)
      get :conduct, params: { id: exam.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #demo_exam' do
    it 'assigns a demo exam to @exam' do
      demo_exam = create(:exam, :demo)
      get :demo_exam, params: { id: demo_exam.id }
      expect(assigns(:exam)).to eq(demo_exam)
    end

    it 'renders the demo_exam template' do
      demo_exam = create(:exam, :demo)
      get :demo_exam, params: { id: demo_exam.id }
      expect(response).to render_template('demo_exam')
    end
  end

  describe 'POST #submit_exam' do
    it 'submits the exam and redirects to exam performance page' do
      user_answers = { '0' => '1', '1' => '2', '2' => '3' }
      performance = create(:exam_performance)
      allow(exam).to receive(:calculate_score).and_return(75)
      post :submit_exam, params: { id: exam.id, user_answers: }
      expect(response).to redirect_to(exam_performance_path(performance.id + 1))
    end
  end
end
# rubocop:enable Metrics/BlockLength
