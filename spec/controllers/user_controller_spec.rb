# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    context 'when a user is not logged in' do
      it 'assigns a new user' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
      end
    end

    context 'when a user is logged in' do
      before { session[:user_id] = user.id }

      it 'redirects to the root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid user parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'logs in the user' do
        post :create, params: { user: attributes_for(:user) }
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to the root path' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid user parameters' do
      it 'does not create a new user' do
        expect do
          post :create, params: { user: { username: '', email: '', password: '' } }
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: { username: '', email: '', password: '' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #show' do
    context 'when the user is logged in' do
      before { session[:user_id] = user.id }

      it 'assigns the requested user to @user' do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        get :show, params: { id: user.id }
        expect(response).to render_template('show')
      end
    end

    context 'when the user is not logged in' do
      it 'requires user authentication' do
        allow(controller).to receive(:current_user).and_return(nil)
        department = create(:department)
        get :show, params: { id: department.id }
        expect(response.status).to eq(404)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
