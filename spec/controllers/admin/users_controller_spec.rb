# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns all users' do
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        user_params = attributes_for(:user)
        expect do
          post :create, params: { user: user_params }
        end.to change(User, :count).by(1)
      end

      it 'assigns admin role to the user' do
        user_params = attributes_for(:user)
        post :create, params: { user: user_params }
        created_user = User.last
        expect(created_user.admin).to be_truthy
      end

      it 'redirects to the users index' do
        user_params = attributes_for(:user)
        post :create, params: { user: user_params }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        invalid_params = { username: '', email: 'invalid_email', password: '' }
        expect do
          post :create, params: { user: invalid_params }
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        invalid_params = { username: '', email: 'invalid_email', password: '' }
        post :create, params: { user: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the user' do
        new_username = 'UpdatedUsername'
        patch :update, params: { id: user.id, user: { username: new_username } }
        user.reload
        expect(user.username).to eq(new_username)
      end

      it 'redirects to the users index' do
        patch :update, params: { id: user.id, user: { username: 'Updated' } }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        invalid_params = { username: '', email: 'invalid_email' }
        patch :update, params: { id: user.id, user: invalid_params }
        user.reload
        expect(user.email).not_to eq('invalid_email')
      end

      it 'renders the edit template' do
        invalid_params = { username: '', email: 'invalid_email' }
        patch :update, params: { id: user.id, user: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the user' do
      user_to_destroy = create(:user)
      expect do
        delete :destroy, params: { id: user_to_destroy.id }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users index' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
