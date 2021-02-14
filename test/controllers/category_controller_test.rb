require "test_helper"

class CategoryControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.create(name: 'Category 1', 
                                description: ('a'*20),
                                user_id: users(:user_one).id)
    sign_in users(:user_one)
  end

  test "1.1 should get new" do
    get categories_new_path
    assert_response :success
  end


  test "1.2 should not get new when not logged in" do
    sign_out :user
    get categories_new_path
    assert_redirected_to new_user_session_path
  end


  test "2.1 should get edit" do
    get categories_edit_path @category
    assert_response :success
  end


  test "2.2 should not get edit when not logged in" do
    sign_out :user
    get categories_edit_path @category
    assert_redirected_to new_user_session_path
  end


  test "2.3 should not get edit when not the owner" do
    self.login_hacker
    get categories_edit_path @category
    assert_redirected_to root_path
  end


  test "3.1 should delete a category" do
    assert_difference('Category.count', -1) do
      delete categories_delete_path @category
    end
  end


  test "3.2 should not delete a category when not logged in" do
    sign_out :user
    assert_no_difference('Category.count') do
      delete categories_delete_path @category
    end
    assert_redirected_to new_user_session_path
  end


  test "3.3 should not delete a category when not the owner" do
    self.login_hacker
    assert_no_difference('Category.count') do
      delete categories_delete_path @category
    end
    assert_redirected_to root_path
  end


  test "4.1 should be able to create a category" do
    assert_difference('Category.count', 1) do
      post categories_create_path, params: { category: { 
        name: 'Category Three',
        description: "a"*21
      } } 
    end

    assert_redirected_to home_dashboard_path
  end


  test "4.2 should not be able to create a category when not logged in" do
    sign_out :user

    assert_no_difference('Category.count') do
      post categories_create_path, params: { category: { 
        name: 'Category Three',
        description: "a"*21
      } } 
    end

    assert_redirected_to new_user_session_path
  end


  test "4.3 should be able to reject a category if name is empty" do

    assert_no_difference('Category.count') do
      post categories_create_path, params: { category: { 
        name: '',
        description: "a"*20
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "4.4 should be able to reject a category if description is empty" do

    assert_no_difference('Category.count') do
      post categories_create_path, params: { category: { 
        name: 'Category Three',
        description: ""
      } } 
    end

    assert_select "input:match('name', ?)", 'name'
    assert_match 'Failed', response.body
  end


  test "5.1 edit should be able to update a category name" do
    patch categories_update_path(@category), params: {
      category: { name: 'UPDATED CATEGORY!' }
    }
    
    assert Category.find(@category.id).name == 'UPDATED CATEGORY!'
    assert_redirected_to home_dashboard_path
  end


  test "5.2 edit should be able to update a category description" do
    patch categories_update_path(@category), params: {
      category: { description: 'UPDATED DESCRIPTION!' }
    }
    
    assert Category.find(@category.id).description == 'UPDATED DESCRIPTION!'
    assert_redirected_to home_dashboard_path
  end


  test "5.3 edit should not be able to update a category description when logged out" do
    sign_out :user
        
    patch categories_update_path(@category), params: {
      category: { description: 'UPDATED DESCRIPTION!' }
    }
    
    assert Category.find(@category.id).description != 'UPDATED DESCRIPTION!'
    assert_redirected_to new_user_session_path
  end


  test "5.4 edit should not be able to update a category name when logged out" do
    sign_out :user

    patch categories_update_path(@category), params: {
      category: { name: 'UPDATED CATEGORY!' }
    }
    
    assert Category.find(@category.id).name != 'UPDATED CATEGORY!'
    assert_redirected_to new_user_session_path
  end


  test "5.5 edit should not be able to update a category name when not the owner" do
    self.login_hacker

    patch categories_update_path(@category), params: {
      category: { name: 'UPDATED CATEGORY!' }
    }
    
    assert Category.find(@category.id).name != 'UPDATED CATEGORY!'
    assert_redirected_to root_path
  end


  test "5.6 edit should not be able to update a category description when not the owner" do
    self.login_hacker
    
    patch categories_update_path(@category), params: {
      category: { description: 'UPDATED DESCRIPTION!' }
    }
    
    assert Category.find(@category.id).description != 'UPDATED DESCRIPTION!'
    assert_redirected_to root_path
  end

end
