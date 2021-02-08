require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', description: ('a'*20))
  end

  test "should get home" do
    get root_path
    assert_response :success
  end


  test "home should have both categories and tasks instance variables" do
    get root_path
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:tasks)
  end


  test "home should have a link to show category tasks" do
    get root_path
    assert_select "a:match('href', ?)", tasks_path(@category)
  end


  test "home should have a link to edit a category" do
    get root_path
    assert_select "a:match('href', ?)", categories_edit_path(@category)
  end


  test "home should have a link to delete a category" do
    get root_path
    assert_select "a:match('href', ?)", categories_delete_path(@category)
  end


  test "home should show the category name" do
    get root_path
    assert_match @category.name, response.body
  end

end
