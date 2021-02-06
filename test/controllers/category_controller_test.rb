require "test_helper"

class CategoryControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1')
  end

  test "1. should get index" do
    get categories_path
    assert_response :success
  end

  test "2. should get new" do
    get categories_new_path
    assert_response :success
  end

  test "3. should get edit" do
    get categories_edit_path 1
    assert_response :success
  end

  test "4. should get show" do
    get categories_show_path 1
    assert_response :success
  end

  test "5. should delete a category" do
    delete categories_delete_path 1
    assert_response :success
  end

  test "6. index should have a link to show a category" do
    get categories_path
    assert_select "a:match('href', ?)", categories_show_path(@category)
  end

  test "7. index should have a link to edit a category" do
    get categories_path
    assert_select "a:match('href', ?)", categories_edit_path(@category)
  end

  test "8. index should have a link to delete a category" do
    get categories_path
    assert_select "a:match('href', ?)", categories_delete_path(@category)
  end

  test "9. index should show the category name" do
    get categories_path
    assert_match @category.name, response.body
  end

end
