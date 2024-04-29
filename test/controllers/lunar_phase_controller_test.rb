require 'test_helper'

class LunarPhaseControllerTest < ActionController::TestCase
  test "should get lunarPhase" do
    get :lunar_phase
    assert_response :success
  end

end
