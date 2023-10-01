# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::ProfessorsController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:department) { create(:department) }
  let(:professor) { create(:professor) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all professors' do
      get :index
      expect(assigns(:professors)).to include(professor)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new professor' do
      get :new
      expect(assigns(:professor)).to be_a_new(Professor)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: professor.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested professor' do
      get :edit, params: { id: professor.id }
      expect(assigns(:professor)).to eq(professor)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new professor' do
        professor_params = attributes_for(:professor, department_id: department.id)
        expect do
          post :create, params: { professor: professor_params }
        end.to change(Professor, :count).by(1)
      end

      it 'redirects to the professors index' do
        professor_params = attributes_for(:professor, department_id: department.id)
        post :create, params: { professor: professor_params }
        expect(response).to redirect_to(admin_professors_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new professor' do
        invalid_params = { name: '', department_id: department.id }
        expect do
          post :create, params: { professor: invalid_params }
        end.not_to change(Professor, :count)
      end

      it 'renders the new template' do
        invalid_params = { name: '', department_id: department.id }
        post :create, params: { professor: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the professor' do
        new_name = 'Updated Professor Name'
        patch :update, params: { id: professor.id, professor: { name: new_name } }
        professor.reload
        expect(professor.name).to eq(new_name)
      end

      it 'redirects to the professors index' do
        patch :update, params: { id: professor.id, professor: { name: 'Updated' } }
        expect(response).to redirect_to(admin_professors_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the professor' do
        invalid_params = { name: '' }
        patch :update, params: { id: professor.id, professor: invalid_params }
        professor.reload
        expect(professor.name).not_to eq('')
      end

      it 'renders the edit template' do
        invalid_params = { name: '' }
        patch :update, params: { id: professor.id, professor: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the professor' do
      professor_to_destroy = create(:professor)
      expect do
        delete :destroy, params: { id: professor_to_destroy.id }
      end.to change(Professor, :count).by(-1)
    end

    it 'redirects to the professors index' do
      delete :destroy, params: { id: professor.id }
      expect(response).to redirect_to(admin_professors_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
