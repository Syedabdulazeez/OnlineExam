# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::QuestionsController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:exam) { create(:exam) }
  let(:question) { create(:question, exam:) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all questions' do
      get :index
      expect(assigns(:questions)).to include(question)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new question' do
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: question.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested question' do
      get :edit, params: { id: question.id }
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new question' do
        question_params = attributes_for(:question, exam_id: exam.id)
        expect do
          post :create, params: { question: question_params }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to the questions index' do
        question_params = attributes_for(:question, exam_id: exam.id)
        post :create, params: { question: question_params }
        expect(response).to redirect_to(admin_questions_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new question' do
        invalid_params = { question_text: '', exam_id: exam.id }
        expect do
          post :create, params: { question: invalid_params }
        end.not_to change(Question, :count)
      end

      it 'renders the new template' do
        invalid_params = { question_text: '', exam_id: exam.id }
        post :create, params: { question: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the question' do
        new_text = 'Updated Question Text'
        patch :update, params: { id: question.id, question: { question_text: new_text } }
        question.reload
        expect(question.question_text).to eq(new_text)
      end

      it 'redirects to the questions index' do
        patch :update, params: { id: question.id, question: { question_text: 'Updated' } }
        expect(response).to redirect_to(admin_questions_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the question' do
        invalid_params = { question_text: '' }
        patch :update, params: { id: question.id, question: invalid_params }
        question.reload
        expect(question.question_text).not_to eq('')
      end

      it 'renders the edit template' do
        invalid_params = { question_text: '' }
        patch :update, params: { id: question.id, question: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the question' do
      question_to_destroy = create(:question)
      expect do
        delete :destroy, params: { id: question_to_destroy.id }
      end.to change(Question, :count).by(-1)
    end

    it 'redirects to the questions index' do
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to(admin_questions_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
