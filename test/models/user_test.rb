require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.create(email: 'sampleuser@gmail.com',
                        password: '987654321',
                        password_confirmation: '987654321',
                        first_name: 'User One',
                        last_name: 'Last Name')
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "user should reject empty email" do
    @user.email = ''
    assert_not @user.valid?
  end

  test "user should reject empty password" do
    @user.password = ''
    assert_not @user.valid?
  end

  test "user should reject empty password_confirmation" do
    @user.password_confirmation = ''
    assert_not @user.valid?
  end

  test "user should reject empty first_name" do
    @user.first_name = ''
    assert_not @user.valid?
  end

  test "user should reject empty last_name" do
    @user.last_name = ''
    assert_not @user.valid?
  end

  test "user should reject duplicated emails" do
    another_user = User.create(email: 'sampleuser@gmail.com',
                        password: '987654321',
                        password_confirmation: '987654321',
                        first_name: 'User One',
                        last_name: 'Last Name')

    assert_not another_user.valid?
  end

  test "user should reject unmatched password and confirmation password" do
    @user.password_confirmation = '123456789'
    assert_not @user.valid?
  end

  test "user should accept correct password" do
    assert @user.valid_password?('987654321')
  end

  test "user should reject incorrect password" do
    assert_not @user.valid_password?('fasdfasfsadf')
  end

  test "user should reject passwords that is less than 6 chars in length" do
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert_not @user.valid?
  end

end
