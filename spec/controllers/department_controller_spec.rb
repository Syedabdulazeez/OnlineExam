# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:department) { create(:department) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the requested department to @department' do
      get :show, params: { id: department.id }
      expect(assigns(:department)).to eq(department)
    end

    it 'renders the show template' do
      get :show, params: { id: department.id }
      expect(response).to render_template('show')
    end

    it 'redirects to 404 page when department is not found' do
      get :show, params: { id: 'nonexistent_id' }
      expect(response.status).to eq(404)
    end
  end
end
