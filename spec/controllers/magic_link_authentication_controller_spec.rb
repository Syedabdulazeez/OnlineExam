# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MagicLinkAuthenticationController, type: :controller do
  describe 'POST #create' do
    context 'when a user with the given email exists' do
      let(:user) { create(:user, email: 'user@example.com') }

      it 'generates a magic link token and sends an email' do
        expect_any_instance_of(User).to receive(:generate_magic_link_token)
        expect(UserMailer).to receive(:magic_link_email).with(user).and_return(double(deliver_now: true))

        post :create, params: { email: 'user@example.com' }

        expect(flash[:success]).to eq('Magic link has been sent to your email.')
        expect(response.status).to eq(200)
      end
    end

    context 'when a user with the given email does not exist' do
      it 'sets a danger flash message and redirects to root path' do
        post :create, params: { email: 'nonexistent@example.com' }

        expect(flash[:danger]).to eq('User with this email does not exist.')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
