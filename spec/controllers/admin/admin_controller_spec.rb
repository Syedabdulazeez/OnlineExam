# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Admin::AdminController, type: :controller do
  describe 'GET #index' do
    it 'returns http success when an admin is logged in' do
      admin_user = create(:user, admin: true)
      allow(controller).to receive(:current_user).and_return(admin_user)

      get :index

      expect(response).to have_http_status(:success)
    end

    it 'redirects to the root path when a regular user is logged in' do
      regular_user = create(:user)
      allow(controller).to receive(:current_user).and_return(regular_user)

      get :index

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to the root path when no user is logged in' do
      allow(controller).to receive(:current_user).and_return(nil)

      get :index

      expect(response).to redirect_to(root_path)
    end
  end
end
