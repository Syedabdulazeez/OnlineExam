# frozen_string_literal: true

require 'test_helper'

class MagicLinkAuthenticationControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get magic_link_authentication_create_url
    assert_response :success
  end
end
