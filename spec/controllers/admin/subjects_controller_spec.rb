# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::SubjectsController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:department) { create(:department) }
  let(:subject) { create(:subject, department:) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all subjects' do
      get :index
      expect(assigns(:subjects)).to include(subject)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new subject' do
      get :new
      expect(assigns(:subject)).to be_a_new(Subject)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: subject.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested subject' do
      get :edit, params: { id: subject.id }
      expect(assigns(:subject)).to eq(subject)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new subject' do
        subject_params = attributes_for(:subject, department_id: department.id)
        expect do
          post :create, params: { subject: subject_params }
        end.to change(Subject, :count).by(1)
      end

      it 'redirects to the subjects index' do
        subject_params = attributes_for(:subject, department_id: department.id)
        post :create, params: { subject: subject_params }
        expect(response).to redirect_to(admin_subjects_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new subject' do
        invalid_params = { subject_name: '', department_id: department.id }
        expect do
          post :create, params: { subject: invalid_params }
        end.not_to change(Subject, :count)
      end

      it 'renders the new template' do
        invalid_params = { subject_name: '', department_id: department.id }
        post :create, params: { subject: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the subject' do
        new_name = 'Updated Subject Name'
        patch :update, params: { id: subject.id, subject: { subject_name: new_name } }
        subject.reload
        expect(subject.subject_name).to eq(new_name)
      end

      it 'redirects to the subjects index' do
        patch :update, params: { id: subject.id, subject: { subject_name: 'Updated' } }
        expect(response).to redirect_to(admin_subjects_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the subject' do
        invalid_params = { subject_name: '' }
        patch :update, params: { id: subject.id, subject: invalid_params }
        subject.reload
        expect(subject.subject_name).not_to eq('')
      end

      it 'renders the edit template' do
        invalid_params = { subject_name: '' }
        patch :update, params: { id: subject.id, subject: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the subject' do
      subject_to_destroy = create(:subject)
      expect do
        delete :destroy, params: { id: subject_to_destroy.id }
      end.to change(Subject, :count).by(-1)
    end

    it 'redirects to the subjects index' do
      delete :destroy, params: { id: subject.id }
      expect(response).to redirect_to(admin_subjects_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
