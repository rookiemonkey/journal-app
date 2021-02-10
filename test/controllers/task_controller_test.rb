require "test_helper"

class TaskControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_one).id)

    @task = Task.create(name: 'Task One', 
                        description: ('b'*50), 
                        deadline: '2021-12-25',
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


  test "1.3 index should have @category instance variable" do
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


  test "2.1 should not get new if not logged in" do
    sign_out :user
    get tasks_new_path(id: @category.id)
    assert_redirected_to signin_new_path
  end


  test "2.3 should be able to create a task" do
    old_tasks_count = Category.find(@category.id).tasks.length

    assert_difference('Task.count', 1) do
      post tasks_create_path(id: @category.id), params: {
        task: { name: 'Task Two!', description: ("a"*50), deadline: "2021-12-26" }
      }
    end

    assert Category.find(@category.id).tasks.length > old_tasks_count
  end


  test "2.4 should not be able to create a task if not logged in" do
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


  test "3.3 should be able to update task name" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { name: 'UPDATED TASK!' }
    }
    assert Task.find(@task.id).name == 'UPDATED TASK!'
  end


  test "3.4 should not be able to update task name if not logged in" do
    sign_out :user
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { name: 'UPDATED TASK!' }
    }
    assert Task.find(@task.id).name != 'UPDATED TASK!'
    assert_redirected_to signin_new_path
  end


  test "3.5 should be able to update task description" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { description: 'UPDATED DESCRIPTION!' }
    }
    assert Task.find(@task.id).description == 'UPDATED DESCRIPTION!'
  end


  test "3.6 should not be able to update task description if not logged in" do
    sign_out :user
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { description: 'UPDATED DESCRIPTION!' }
    }
    assert Task.find(@task.id).description != 'UPDATED DESCRIPTION!'
    assert_redirected_to signin_new_path
  end


  test "3.7 should be able to update deadline" do
    patch tasks_update_path(id: @task.category_id, tid: @task.id), params: {
      task: { deadline: '2021-02-20' }
    }
    assert Task.find(@task.id).deadline == '2021-02-20'
  end


  test "3.8 should be able to update deadline if not logged in" do
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

end
