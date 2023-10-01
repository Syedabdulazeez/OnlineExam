# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::ExamsController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:subject) { create(:subject) }
  let(:exam) { create(:exam) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all exams' do
      get :index
      expect(assigns(:exams)).to include(exam)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: exam.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested exam' do
      get :show, params: { id: exam.id }
      expect(assigns(:exam)).to eq(exam)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: exam.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested exam' do
      get :edit, params: { id: exam.id }
      expect(assigns(:exam)).to eq(exam)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the exam' do
        new_name = 'Updated Exam Name'
        patch :update, params: { id: exam.id, exam: { exam_name: new_name } }
        exam.reload
        expect(exam.exam_name).to eq(new_name)
      end

      it 'redirects to the exams index' do
        patch :update, params: { id: exam.id, exam: { exam_name: 'Updated' } }
        expect(response).to redirect_to(admin_exams_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the exam' do
        invalid_params = { exam_name: '' }
        patch :update, params: { id: exam.id, exam: invalid_params }
        exam.reload
        expect(exam.exam_name).not_to eq('')
      end

      it 'renders the edit template' do
        invalid_params = { exam_name: '' }
        patch :update, params: { id: exam.id, exam: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new exam' do
      get :new
      expect(assigns(:exam)).to be_a_new(Exam)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new exam' do
        exam_params = attributes_for(:exam, subject_id: subject.id)
        expect do
          post :create, params: { exam: exam_params }
        end.to change(Exam, :count).by(1)
      end

      it 'redirects to the exams index' do
        exam_params = attributes_for(:exam, subject_id: subject.id)
        post :create, params: { exam: exam_params }
        expect(response).to redirect_to(admin_exams_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new exam' do
        invalid_params = { exam_name: '', subject_id: subject.id }
        expect do
          post :create, params: { exam: invalid_params }
        end.not_to change(Exam, :count)
      end

      it 'renders the new template' do
        invalid_params = { exam_name: '', subject_id: subject.id }
        post :create, params: { exam: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the exam' do
      exam_to_destroy = create(:exam)
      expect do
        delete :destroy, params: { id: exam_to_destroy.id }
      end.to change(Exam, :count).by(-1)
    end

    it 'redirects to the exams index' do
      delete :destroy, params: { id: exam.id }
      expect(response).to redirect_to(admin_exams_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
