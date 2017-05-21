require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  test "should be able to GET index" do
    get :index
    assert_response :success
  end

end
