require "test_helper"

class ForgotPasswordFlowsTest < ActionDispatch::IntegrationTest

  test "1.1 FORGOT PASSWORD. able to get the forgot password form" do
    get new_user_password_path
    assert_response :success
  end


  test "1.2 FORGOT PASSWORD. able to send password reset intructions via email" do
    post user_password_path, params: { user: { email: users(:user_one).email } }
    assert_redirected_to new_user_session_path

    follow_redirect!
    assert_match "Password reset was sent to MailTrap Testing email testing service", response.body
  end


  test "1.3 FORGOT PASSWORD. able to get the password reset form using the token" do
    token = users(:user_one).send_reset_password_instructions
    reset_password_url = "#{edit_user_password_url}?reset_password_token=#{token}"
    get reset_password_url
    assert_response :success
  end


  test "1.4 FORGOT PASSWORD. able to reject accessing password reset form w/o any token" do
    reset_password_url = "#{edit_user_password_url}?reset_password_token="
    get reset_password_url
    follow_redirect!
    assert_match "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided", response.body
  end
  

  test "1.5 FORGOT PASSWORD. able to change the password" do
    old_password_encrypted = users(:user_one).encrypted_password
    
    token = users(:user_one).send_reset_password_instructions
    reset_password_url = "#{edit_user_password_url}?reset_password_token=#{token}"

    get reset_password_url
    put user_password_path, params: {
      user: { 
        password: '123456789', 
        password_confirmation: '123456789',
        reset_password_token: token
      }
    } 

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Your password has been changed successfully. You are now signed in.", response.body

    users(:user_one).reload
    assert users(:user_one).valid_password? '123456789'
    assert_not users(:user_one).valid_password? '987654321'
    assert_not_equal users(:user_one).encrypted_password, old_password_encrypted
  end


  test "1.5 FORGOT PASSWORD. able to reject new password with less than 6 chars" do
    token = users(:user_one).send_reset_password_instructions
    reset_password_url = "#{edit_user_password_url}?reset_password_token=#{token}"

    get reset_password_url
    put user_password_path, params: {
      user: { 
        password: '12345', 
        password_confirmation: '12345',
        reset_password_token: token
      }
    } 

    assert_match "<li><b>PASSWORD</b> is too short (minimum is 6 characters)</li>", response.body
  end


  test "1.5 FORGOT PASSWORD. able to reject new password that doesn't match with the confirmation" do
    token = users(:user_one).send_reset_password_instructions
    reset_password_url = "#{edit_user_password_url}?reset_password_token=#{token}"

    get reset_password_url
    put user_password_path, params: {
      user: { 
        password: '123456789', 
        password_confirmation: 'abcdefghijl',
        reset_password_token: token
      }
    } 

    assert_match "<li><b>PASSWORD CONFIRMATION</b> doesn&#39;t match Password</li>", response.body
  end

end
