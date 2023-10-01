# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, username: 'testuser', password: 'password') }

  describe 'GET #new' do
    context 'when not logged in' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when logged in' do
      before { log_in(user) }

      it 'redirects to root_path with a success message' do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('login successful')
      end
    end
  end

  describe 'POST #create' do
    it 'logs in a user with valid credentials' do
      post :create, params: { username: user.username, password: 'password' }
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq('login success')
    end

    it 'fails to log in with invalid credentials' do
      post :create, params: { username: user.username, password: 'wrong_password' }
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:danger]).to eq('Incorrect username or password.')
    end
  end

  describe 'DELETE #destroy' do
    before { log_in(user) }

    it 'logs out the user' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:success]).to eq('logout successful')
    end
  end
end
# rubocop:enable Metrics/BlockLength
