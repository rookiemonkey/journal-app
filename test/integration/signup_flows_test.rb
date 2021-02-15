require "test_helper"

class AccountFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @user = {
        first_name: 'Testing',
        last_name: 'User',
        email: 'sampleemail@gmail.com',
        password: '987654321',
        password_confirmation: '987654321'
      }
  end

  test "1.1 SIGNUP. able to signup to access the application and redirected to dashboard" do

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }

    assert_redirected_to home_dashboard_path

  end


  test "1.2.1 SIGNUP. able to reject user signup with first_name" do
    @user[:first_name] = ''

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }

    assert_match "<li><b>FIRST NAME</b> can&#39;t be blank</li>", response.body
  end


  test "1.2.2 SIGNUP. able to reject user signup with first_name greater than 15 chars" do
    @user[:first_name] = ('a'*16)

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }

    assert_match "<li><b>FIRST NAME</b> is too long (maximum is 15 characters)</li>", response.body
  end


  test "1.3.1 SIGNUP. able to reject user signup with empty last_name" do
    @user[:last_name] = ''

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }

    assert_match "<li><b>LAST NAME</b> can&#39;t be blank</li>", response.body
  end


  test "1.3.2 SIGNUP. able to reject user signup with last_name greater than 30 chars" do
    @user[:last_name] = ('a'*31)

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }

    assert_match "<li><b>LAST NAME</b> is too long (maximum is 30 characters)</li>", response.body
  end


  test "1.4.1 SIGNUP. able to reject user signup with empty email" do
    @user[:email] = ''

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }
    
    assert_match "<li><b>EMAIL</b> can&#39;t be blank</li>", response.body
  end


  test "1.4.2 SIGNUP. able to reject user signup with incorrect email format" do
    @user[:email] = 'aslkdfagmail.comskdj'

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }
    
    assert_match "<li><b>EMAIL</b> is invalid</li>", response.body
  end


  test "1.5.1 SIGNUP. able to reject user signup with password length shorter than 6" do
    @user[:password] = ('a'*5)

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }
    
    assert_match "<li><b>PASSWORD</b> is too short (minimum is 6 characters)</li>", response.body
  end


  test "1.5.2 SIGNUP. able to reject user signup with unmatch password and password_confirmation" do
    @user[:password] = ('a'*6)
    @user[:password_confirmation] = ('b'*6)

    get new_user_registration_path
    post signup_create_path, params: {
      user: @user
    }
    
    assert_match "<li><b>PASSWORD CONFIRMATION</b> doesn&#39;t match Password</li>", response.body
  end
  
end
