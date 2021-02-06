require "test_helper"

class CategoryControllerTest < ActionDispatch::IntegrationTest

  test "1. should get all the categories" do
    get categories_path
    assert_response :success
  end

  test "2. should get a form to create category" do
    get categories_new_path
    assert_response :success
  end

  test "3. should get a form to edit a category" do
    get categories_edit_path 1
    assert_response :success
  end

  test "4. should show a category" do
    get categories_show_path 1
    assert_response :success
  end

  test "4. should delete a category" do
    delete categories_delete_path 1
    assert_response :success
  end

end
