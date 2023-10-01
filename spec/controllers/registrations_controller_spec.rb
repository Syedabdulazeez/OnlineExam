# frozen_string_literal: true

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }
  let(:exam) { create(:exam) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'renders the index template when logged in' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'redirects to root_path when not logged in' do
      allow(controller).to receive(:logged_in?).and_return(false)
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #new' do
    it 'assigns @disable_links when exam has started' do
      exam.start_time = Time.current - 1.hour
      exam.save

      get :new, params: { exam_id: exam.id }
      expect(assigns(:disable_links)).to be(true)
    end

    it 'assigns @disable_links when exam has not started' do
      exam.start_time = Time.current + 1.hour
      exam.save

      get :new, params: { exam_id: exam.id }
      expect(assigns(:disable_links)).to be(false)
    end
  end

  describe 'POST #create' do
    it 'creates a registration and redirects on successful registration' do
      post :create, params: { exam_id: exam.id }

      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq('Successfully registered!')
    end
  end
end
# rubocop:enable Metrics/BlockLength
