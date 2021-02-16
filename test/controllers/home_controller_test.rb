require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_one).id)
                                
    sign_in users(:user_one)
  end


  test "0.1 should get homepage" do
    get root_path
    assert_response :success
  end


  test "1.1 should get dashboard only if logged in" do
    get home_dashboard_path
    assert_response :success
  end


  test "1.2 should be redirected when accessing dashboard while not logged in" do
    sign_out :user
    get home_dashboard_path
    assert_redirected_to new_user_session_path
  end


  test "1.3 dashboard should have both categories and tasks instance variables" do
    get home_dashboard_path
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:tasks)
  end


  test "1.4 dashboard should have statistics of the users categories/tasks" do
    get home_dashboard_path
    assert_not_nil assigns(:statistics)
  end


  test "1.5 statistics should return total num of completed/uncompleted tasks for the whole account" do
    self.setup_statistics
    completed_tasks = Task.where(user_id: users(:user_one).id, completed: true)
    incompleted_tasks = Task.where(user_id: users(:user_one).id, completed: false)

    get home_dashboard_path
    count = controller.instance_variable_get(:@statistics)[:count]

    assert count.fetch(:completed) == completed_tasks.count
    assert count.fetch(:not_completed) == incompleted_tasks.count
  end

  test "1.6 statistics should return total num of completed/uncompleted tasks per category/journal" do
    self.setup_statistics
    user_tasks = Task.where(user_id: users(:user_one).id)
    user_categories = Category.where(user_id: users(:user_one).id)

    get home_dashboard_path
    categories = controller.instance_variable_get(:@statistics)[:categories]

    categories.each do |key, hash_value|
      category = Category.find key

      num_of_completed_task = category.tasks.select { |t| t.completed }.length
      num_of_incompleted_task = category.tasks.reject { |t| t.completed }.length

      assert categories[key][:completed] == num_of_completed_task
      assert categories[key][:not_completed] == num_of_incompleted_task
    
    end

    assert categories.length == user_categories.length
  end


  test "1.7 dashboard should have a link to show category tasks" do
    get home_dashboard_path
    assert_select "a:match('href', ?)", tasks_path(@category)
  end


  test "1.8 dashboard should have a link to edit a category" do
    get home_dashboard_path
    assert_select "a:match('href', ?)", categories_edit_path(@category)
  end


  test "1.9 dashboard should show the category name" do
    get home_dashboard_path
    assert_match @category.name, response.body
  end


  test "1.10 dashboard should only show categories for the current user" do
    self.generate_category('Ten', users(:user_two).id)
    self.generate_category('Nine', users(:user_two).id)

    user_categories = Category.where(user_id: users(:user_one).id)
    all_categories = Category.all

    for_user = all_categories.select { |c| c.user_id == users(:user_one).id }

    assert for_user.length == user_categories.length
    assert all_categories.length > user_categories.length

    get home_dashboard_path
    assert controller.instance_variable_get(:@categories).length == user_categories.length
  end


  test "1.11 dashboard should only show overdue/due today incomplete tasks for the current user" do
    self.generate_task('Ten', users(:user_two).id)
    self.generate_task('Nine', users(:user_two).id)
    now = Time.now

    tasks(:task_overdue).category_id = @category.id
    tasks(:task_overdue).user_id = users(:user_one).id
    tasks(:task_overdue).save

    Task.create(name: 'Task One', 
                      description: "<p>#{('b'*50)}</p>", 
                      deadline: "#{now.year}-#{now.month}-#{now.day}",
                      user_id: users(:user_one).id,
                      category_id: @category.id)

    task_today_two = Task.create(name: 'Task Two', 
                      description: "<p>#{('b'*50)}</p>", 
                      deadline: "#{now.year}-#{now.month}-#{now.day}",
                      user_id: users(:user_one).id,
                      category_id: @category.id)

    task_today_two.completed = true
    task_today_two.save

    user_tasks = Task.near_deadline.where(user_id: users(:user_one).id);
    all_tasks = Task.all

    for_user = all_tasks.select { |c| c.user_id == users(:user_one).id }

    assert for_user.length >= user_tasks.length
    assert all_tasks.length > user_tasks.length

    get home_dashboard_path
    assert controller.instance_variable_get(:@tasks).length == user_tasks.length
  end
  

  test "2.1 home_new_task_path should show a form" do
    get home_new_task_path
    assert_response :success
  end


  test "2.2 should be redirected when accessing home_new_task_path while not logged in" do
    sign_out :user
    get home_new_task_path
    assert_redirected_to new_user_session_path
  end


  test "3.1 home_create_task_path should create a task associated to the category" do
    old_count = @category.tasks.count

    assert_difference('Task.count', 1) do
      post home_create_task_path, params: {
        task: {
          name: 'Task Name',
          description: '<p>Task Description</p>',
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
          description: "<p>Task Description</p>",
          deadline: '2025-02-20',
          category_id: @category.id
        }
      }
    end

    assert_redirected_to new_user_session_path
  end

end
