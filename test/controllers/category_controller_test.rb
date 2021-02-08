require "test_helper"
require "pp"

class CategoryControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', description: ('a'*20))
  end

  test "1. should get new" do
    get categories_new_path
    assert_response :success
  end


  test "2. should get edit" do
    get categories_edit_path @category
    assert_response :success
  end


  test "3. should delete a category" do
    assert_difference('Category.count', -1) do
      delete categories_delete_path @category
    end
  end

  test "4. should be able to create a category" do

    assert_difference('Category.count', 1) do
      post categories_new_path, params: { category: { 
        name: 'Category Three',
        description: "a"*21
      } } 
    end

    assert_redirected_to categories_path
  end


  test "5. should be able to reject a category if name is empty" do

    assert_no_difference('Category.count') do
      post categories_new_path, params: { category: { 
        name: '',
        description: "a"*20
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "6. should be able to reject a category if description is empty" do

    assert_no_difference('Category.count') do
      post categories_new_path, params: { category: { 
        name: 'Category Three',
        description: ""
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "7. edit should be able to update a category name" do
    patch categories_update_path(@category), params: {
      category: { name: 'UPDATED CATEGORY!' }
    }
    
    assert Category.find(@category.id).name == 'UPDATED CATEGORY!'
    assert_redirected_to categories_path
  end


  test "8. edit should be able to update a category description" do
    patch categories_update_path(@category), params: {
      category: { description: 'UPDATED DESCRIPTION!' }
    }
    
    assert Category.find(@category.id).description == 'UPDATED DESCRIPTION!'
    assert_redirected_to categories_path
  end


  test "9. category new_task should show a form" do
    get categories_new_task_path
    assert_response :success
  end


  test "10. category new_task should create a task associated to the category" do
    old_count = @category.tasks.count

    assert_difference('Task.count', 1) do
      post categories_create_task_path, params: {
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


end
