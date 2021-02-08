require "test_helper"
require "pp"

class CategoryControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', description: ('a'*20))
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
    get categories_edit_path @category
    assert_response :success
  end


  test "5. should delete a category" do
    assert_difference('Category.count', -1) do
      delete categories_delete_path @category
    end
  end


  test "6. index should have a link to show category tasks" do
    get categories_path
    assert_select "a:match('href', ?)", tasks_path(@category)
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


  test "10. index should have a categories instance variable" do
    get categories_path
    assert_not_nil assigns(:categories)
  end


  test "13. should be able to create a category" do

    assert_difference('Category.count', 1) do
      post categories_new_path, params: { category: { 
        name: 'Category Three',
        description: "a"*21
      } } 
    end

    follow_redirect!
    assert_not_nil assigns(:category)
  end


  test "14. should be able to reject a category if name is empty" do

    assert_no_difference('Category.count') do
      post categories_new_path, params: { category: { 
        name: '',
        description: "a"*20
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "15. should be able to reject a category if description is empty" do

    assert_no_difference('Category.count') do
      post categories_new_path, params: { category: { 
        name: 'Category Three',
        description: ""
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "17. edit should be able to update a category name" do
    patch categories_update_path(@category), params: {
      category: { name: 'UPDATED CATEGORY!' }
    }
    
    assert Category.find(@category.id).name == 'UPDATED CATEGORY!'
  end


  test "18. edit should be able to update a category description" do
    patch categories_update_path(@category), params: {
      category: { description: 'UPDATED DESCRIPTION!' }
    }
    
    assert Category.find(@category.id).description == 'UPDATED DESCRIPTION!'
  end

end
