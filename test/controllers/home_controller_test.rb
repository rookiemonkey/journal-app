require "test_helper"
require "pp"

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', description: ('a'*20))
    sign_in users(:user_one)
  end


  test "should get home only if logged in" do
    get root_path
    assert_response :success
  end


  test "should be redirected when accessing home while not logged in" do
    sign_out :user
    get root_path
    assert_redirected_to signin_new_path
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

  
  test "home_new_task_path should show a form" do
    get home_new_task_path
    assert_response :success
  end


  test "should be redirected when accessing home_new_task_path while not logged in" do
    sign_out :user
    get home_new_task_path
    assert_redirected_to signin_new_path
  end


  test "home_create_task_path should create a task associated to the category" do
    old_count = @category.tasks.count

    assert_difference('Task.count', 1) do
      post home_create_task_path, params: {
        task: {
          name: 'Task Name',
          description: 'Task Description',
          deadline: '2025-02-20',
          category_id: @category.id
        }
      }
    end

    assert old_count < @category.tasks.count
  end


  test "home_create_task_path should redirect when creating a task while not logged in" do
    sign_out :user
    assert_no_difference('Task.count') do
      post home_create_task_path, params: {
        task: {
          name: 'Task Name',
          description: 'Task Description',
          deadline: '2025-02-20',
          category_id: @category.id
        }
      }
    end

    assert_redirected_to signin_new_path
  end


end
