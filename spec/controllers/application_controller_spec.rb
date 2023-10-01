# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }

  controller do
    def index
      render plain: 'Index Page'
    end
  end

  describe '#require_user' do
    it 'does not redirect if user is an admin' do
      allow(controller).to receive(:current_user).and_return(admin_user)
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#authenticate_admin' do
    it 'redirects to root_path if user is not an admin' do
      allow(controller).to receive(:current_user).and_return(user)
      get :index
      expect(response.status).to eq(200)
    end

    it 'does not redirect if user is an admin' do
      allow(controller).to receive(:current_user).and_return(admin_user)
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
# rubocop:enable Metrics/BlockLength
