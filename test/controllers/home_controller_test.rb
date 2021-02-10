require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_one).id)
                                
    sign_in users(:user_one)
  end


  test "1.1 should get home only if logged in" do
    get root_path
    assert_response :success
  end


  test "1.2 should be redirected when accessing home while not logged in" do
    sign_out :user
    get root_path
    assert_redirected_to signin_new_path
  end


  test "1.3 home should have both categories and tasks instance variables" do
    get root_path
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:tasks)
  end


  test "1.4 home should have a link to show category tasks" do
    get root_path
    assert_select "a:match('href', ?)", tasks_path(@category)
  end


  test "1.5 home should have a link to edit a category" do
    get root_path
    assert_select "a:match('href', ?)", categories_edit_path(@category)
  end


  test "1.6 home should have a link to delete a category" do
    get root_path
    assert_select "a:match('href', ?)", categories_delete_path(@category)
  end


  test "1.7 home should show the category name" do
    get root_path
    assert_match @category.name, response.body
  end


  test "1.8 home should only show categories for the current user" do
    self.generate_category('Ten')
    self.generate_category('Nine')

    user_categories = Category.where(user_id: users(:user_one).id)
    all_categories = Category.all

    for_user = all_categories.select { |c| c.user_id == users(:user_one).id }

    assert for_user.length == user_categories.length
    assert all_categories.length > user_categories.length

    get root_path
    assert controller.instance_variable_get(:@categories).length == user_categories.length
  end

  
  test "2.1 home_new_task_path should show a form" do
    get home_new_task_path
    assert_response :success
  end


  test "2.2 should be redirected when accessing home_new_task_path while not logged in" do
    sign_out :user
    get home_new_task_path
    assert_redirected_to signin_new_path
  end


  test "3.1 home_create_task_path should create a task associated to the category" do
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


  test "3.2 home_create_task_path should redirect when creating a task while not logged in" do
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


  private
  
  def generate_category(name)
    Category.create(name: "Category #{name}", 
                    description: ('a'*20),
                    user_id: 98989898898989898989)
  end

end
