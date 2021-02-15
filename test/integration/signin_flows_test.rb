require "test_helper"

class SignInFlowsTest < ActionDispatch::IntegrationTest

  def setup # user_one fixture details
    @user = {
      email: "user1@google.com",
      password: "987654321"
    }
  end

  test "1.1 SIGNIN. able to signin and redirect to dashboard" do
    post user_session_path, params: {
      user: @user
    }

    assert_redirected_to home_dashboard_path
  end

  test "2.1 SIGNIN. should reject email not registered" do
    @user[:email] = 'this_is_not_on_the_database@gmail.com'

    post user_session_path, params: {
      user: @user
    }

    assert_match 'Invalid Email or password', response.body
  end

  test "2.2 SIGNIN. should reject incorrect password" do
    @user[:password] = 'incorrectpassword'

    post user_session_path, params: {
      user: @user
    }

    assert_match 'Invalid Email or password', response.body
  end


  test "2.3 SIGNIN. should reject empty email" do
    @user[:email] = ''

    post user_session_path, params: {
      user: @user
    }

    assert_match 'Invalid Email or password', response.body
  end


  test "2.4 SIGNIN. should reject empty password" do
    @user[:password] = ''

    post user_session_path, params: {
      user: @user
    }

    assert_match 'Invalid Email or password', response.body
  end


end
