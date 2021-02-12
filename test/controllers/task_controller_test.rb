require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_one).id)

    now = Time.now

    @task = Task.create(name: 'Task One', 
                        description: ('b'*50), 
                        deadline: "#{now.year}-#{now.month}-#{now.day}",
                        user_id: users(:user_one).id,
                        category_id: @category.id)

    @task.category_id = @category.id
    @category.tasks << @task

    @category.save
    @task.save

    sign_in users(:user_one)
  end

  test "1.1 should get index" do
    get tasks_path @category
    assert_response :success
  end


  test "1.2 should not get index if not logged in" do
    sign_out :user
    get tasks_path @category
    assert_redirected_to signin_new_path
  end


  test "1.3 should not get index of other users" do
    self.login_hacker
    get tasks_path @category
    assert_redirected_to root_path
  end


  test "1.4 index should have @category instance variable" do
    get tasks_path @category
    assert_not_nil assigns(:category)
  end


  test "2.1 should get new" do
    get tasks_new_path(id: @category.id)
    assert_response :success
    assert_select "input:match('name', ?)", 'name'
    assert_select "input:match('name', ?)", 'deadline'
    assert_select "textarea:match('name', ?)", 'description'
  end


  test "2.2 should not get new if not logged in" do
    sign_out :user
    get tasks_new_path(id: @category.id)
    assert_redirected_to signin_new_path
  end


  test "2.3 should not get new if user is not the owner of the journal/category" do
    category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_two).id)

    get tasks_new_path(id: category.id)
    assert_redirected_to root_path
  end


  test "2.4 should not get new if there are no journals on the account" do
    users(:user_one).categories.delete_all
    get home_new_task_path
    assert_redirected_to categories_new_path
  end


  test "2.5 should be able to create a task" do
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_difference('Task.count', 1) do
      post tasks_create_path(id: @category.id), params: {
        task: { name: 'Task Two!', description: ("a"*50), deadline: "2021-12-26" }
      }
    end

    assert Category.find(@category.id).tasks.length > old_tasks_count
  end


  test "2.6 should not be able to create a task if not logged in" do
    sign_out :user
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_no_difference('Task.count') do
      post tasks_create_path(id: @category.id), params: {
        task: { name: 'Task Two!', description: ("a"*50), deadline: "2021-12-26" }
      }
    end

    assert Category.find(@category.id).tasks.length == old_tasks_count
    assert_redirected_to signin_new_path
  end


  test "3.1 should get edit" do
    get tasks_edit_path(id: @task.category_id, tid: @task.id)
    assert_not_nil assigns(:task)
    assert_select "input:match('name', ?)", 'name'
    assert_select "input:match('name', ?)", 'deadline'
    assert_select "textarea:match('name', ?)", 'description'
  end


  test "3.2 should not get edit if not logged in" do
    sign_out :user
    get tasks_edit_path(id: @task.category_id, tid: @task.id)
    assert_redirected_to signin_new_path
  end


  test "3.3 should not get edit if not the owner" do
    self.login_hacker
    get tasks_edit_path(id: @task.category_id, tid: @task.id)
    assert_redirected_to root_path
  end


  test "3.4 should be able to update task name" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { name: 'UPDATED TASK!' }
    }
    assert Task.find(@task.id).name == 'UPDATED TASK!'
  end


  test "3.5 should not be able to update task name if not the owner" do
    self.login_hacker
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { name: 'UPDATED TASK!' }
    }
    assert Task.find(@task.id).name != 'UPDATED TASK!'
    assert_redirected_to root_path
  end


  test "3.6 should not be able to update task name if not logged in" do
    sign_out :user
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { name: 'UPDATED TASK!' }
    }
    assert Task.find(@task.id).name != 'UPDATED TASK!'
    assert_redirected_to signin_new_path
  end


  test "3.7 should be able to update task description" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { description: 'UPDATED DESCRIPTION!' }
    }
    assert Task.find(@task.id).description == 'UPDATED DESCRIPTION!'
  end


  test "3.8 should not be able to update task description if not the owner" do
    self.login_hacker
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { description: 'UPDATED DESCRIPTION!' }
    }
    assert Task.find(@task.id).description != 'UPDATED DESCRIPTION!'
    assert_redirected_to root_path
  end


  test "3.9 should not be able to update task description if not logged in" do
    sign_out :user
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { description: 'UPDATED DESCRIPTION!' }
    }
    assert Task.find(@task.id).description != 'UPDATED DESCRIPTION!'
    assert_redirected_to signin_new_path
  end


  test "3.10 should be able to update deadline" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { deadline: '2021-02-20' }
    }
    assert Task.find(@task.id).deadline == '2021-02-20'
  end


  test "3.11 should be able to update deadline if not the owner" do
     self.login_hacker
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { deadline: '2021-02-20' }
    }
    assert Task.find(@task.id).deadline != '2021-02-20'
    assert_redirected_to root_path
  end


  test "3.12 should be able to update deadline if not logged in" do
    sign_out :user
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { deadline: '2021-02-20' }
    }
    assert Task.find(@task.id).deadline != '2021-02-20'
    assert_redirected_to signin_new_path
  end


  test "4.1 should be able to delete task" do
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_difference('Task.count', -1) do 
      delete tasks_delete_path(id: @task.category_id, tid: @task.id)
    end

    assert Category.find(@category.id).tasks.length < old_tasks_count
  end


  test "4.2 should not be able to delete task if not logged in" do
    sign_out :user
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_no_difference('Task.count', -1) do 
      delete tasks_delete_path(id: @task.category_id, tid: @task.id)
    end

    assert Category.find(@category.id).tasks.length == old_tasks_count
    assert_redirected_to signin_new_path
  end


  test "4.3 should not be able to delete task if not the owner" do
    self.login_hacker
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_no_difference('Task.count', -1) do 
      delete tasks_delete_path(id: @task.category_id, tid: @task.id)
    end

    assert Category.find(@category.id).tasks.length == old_tasks_count
    assert_redirected_to root_path
  end


  test "5.1 should get show task" do
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_response :success
  end


  test "5.2 should have @task instance variable on show task" do
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_not_nil assigns(:task)
  end


  test "5.3 should show the task name" do
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match @task.name, response.body
  end


  test "5.3 should show the task description" do
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match @task.description, response.body
  end


  test "5.4 should show the task description" do
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match @task.description, response.body
  end


  test "5.6 should show the task status pending" do
    future = Time.now
    @task.deadline = "#{future.year+1}-01-01"
    @task.save
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match 'Pending', response.body
  end


  test "5.7 should show the task status completed" do
    @task.completed = true
    @task.save
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match 'Completed', response.body
  end


  test "5.8 should show the task status Overdue" do
    tasks(:task_overdue).category_id = @category.id
    tasks(:task_overdue).user_id = users(:user_one).id
    tasks(:task_overdue).save

    get tasks_show_path(id: tasks(:task_overdue).category_id, tid: tasks(:task_overdue).id)
    assert_match 'Overdue', response.body
  end


  test "5.9 should show the task status Due Today" do
    now = Time.now

    task = Task.create(name: 'Task One', 
                        description: ('b'*50), 
                        deadline: "#{now.year}-#{now.month}-#{now.day}",
                        user_id: users(:user_one).id,
                        category_id: @category.id);
    

    get tasks_show_path(id: task.category_id, tid: task.id)
    assert_match 'Due Today', response.body
  end


  test "5.10 should show the task deadline" do
    # format should be based on date_full_words on application helpers
    get tasks_show_path(id: @task.category_id, tid: @task.id)
    assert_match @task.deadline.strftime("%A, %d %b %Y"), response.body
  end

end
