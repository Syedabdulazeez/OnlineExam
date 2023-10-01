# frozen_string_literal: true

# spec/controllers/subjects_controller_spec.rb

require 'rails_helper'

RSpec.describe SubjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:department) { create(:department) }
  let(:subject) { create(:subject, department:) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the subject and related exams' do
      exam1 = create(:exam, subject:)
      exam2 = create(:exam, subject:)

      get :show, params: { id: subject.id }

      expect(assigns(:subject)).to eq(subject)
      expect(assigns(:exams)).to match_array([exam1, exam2])
      expect(response).to render_template(:show)
    end

    it 'redirects to 404 page when subject is not found' do
      get :show, params: { id: 'nonexistent_id' }

      expect(response.status).to eq(404)
    end
  end
end
