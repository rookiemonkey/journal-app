require "test_helper"
require "pp"

class TaskControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', description: ('a'*20))
    @task = Task.create(name: 'Task One')

    @task.category_id = @category.id
    @category.tasks << @task

    @category.save
    @task.save
  end

  test "1.1 should get index" do
    get tasks_path @category
    assert_response :success
  end

  test "1.2 index should have @category instance variable" do
    get tasks_path @category
    assert_not_nil assigns(:category)
  end

  test "2.1 should get new" do
    get tasks_new_path(id: @task.category_id)
    assert_response :success
    assert_select "input:match('name', ?)", 'name'
    assert_select "input:match('name', ?)", 'deadline'
    assert_select "textarea:match('name', ?)", 'description'
  end

  test "3.1 should get edit" do
    get tasks_edit_path(id: @task.category_id, tid: @task.id)
    assert_not_nil assigns(:task)
    assert_select "input:match('name', ?)", 'name'
    assert_select "input:match('name', ?)", 'deadline'
    assert_select "textarea:match('name', ?)", 'description'
  end



end
