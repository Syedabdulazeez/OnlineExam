# frozen_string_literal: true

# spec/controllers/admin/departments_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::DepartmentsController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:department) { create(:department) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all departments' do
      get :index
      expect(assigns(:departments)).to include(department)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new department' do
      get :new
      expect(assigns(:department)).to be_a_new(Department)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new department' do
        department_params = attributes_for(:department)
        expect do
          post :create, params: { department: department_params }
        end.to change(Department, :count).by(1)
      end

      it 'redirects to the departments index' do
        department_params = attributes_for(:department)
        post :create, params: { department: department_params }
        expect(response).to redirect_to(admin_departments_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new department' do
        invalid_params = { department_name: '' }
        expect do
          post :create, params: { department: invalid_params }
        end.not_to change(Department, :count)
      end

      it 'renders the new template' do
        invalid_params = { department_name: '' }
        post :create, params: { department: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: department.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested department' do
      get :edit, params: { id: department.id }
      expect(assigns(:department)).to eq(department)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the department' do
        new_name = 'Updated Department Name'
        patch :update, params: { id: department.id, department: { department_name: new_name } }
        department.reload
        expect(department.department_name).to eq(new_name)
      end

      it 'redirects to the departments index' do
        patch :update, params: { id: department.id, department: { department_name: 'Updated' } }
        expect(response).to redirect_to(admin_departments_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the department' do
        invalid_params = { department_name: '' }
        patch :update, params: { id: department.id, department: invalid_params }
        department.reload
        expect(department.department_name).not_to eq('')
      end

      it 'renders the edit template' do
        invalid_params = { department_name: '' }
        patch :update, params: { id: department.id, department: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the department' do
      department_to_destroy = create(:department)
      expect do
        delete :destroy, params: { id: department_to_destroy.id }
      end.to change(Department, :count).by(-1)
    end

    it 'redirects to the departments index' do
      delete :destroy, params: { id: department.id }
      expect(response).to redirect_to(admin_departments_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
