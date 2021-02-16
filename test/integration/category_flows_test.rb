require "test_helper"

class CategoryFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @category = {
      name: 'Test Journal',
      description: 'Test Journal Description'
    }
    sign_in users(:user_one)
  end


  test "1.1 CATEGORY. should be able to create a category" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    post categories_create_path, params: { category: @category }
    assert_redirected_to home_dashboard_path
    follow_redirect!

    new_count = Category.where(user_id: users(:user_one).id).count

    assert (new_count-old_count) == 1
    assert_match "Successfully created your journal", response.body
  end


  test "1.2 CATEGORY. should be able to reject a category with empty name" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    @category[:name] = ''
    post categories_create_path, params: { category: @category }

    new_count = Category.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "Failed to create journal", response.body
    assert_match "<li><b>NAME</b> can&#39;t be blank</li>", response.body
  end


  test "1.3 CATEGORY. should be able to reject a category with name longer than 20 chars" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    @category[:name] = ('a'*21)
    post categories_create_path, params: { category: @category }

    new_count = Category.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "Failed to create journal", response.body
    assert_match "<li><b>NAME</b> is too long (maximum is 20 characters)</li>", response.body
  end


  test "1.4 CATEGORY. should be able to reject a category with empty description" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    @category[:description] = ''
    post categories_create_path, params: { category: @category }

    new_count = Category.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "Failed to create journal", response.body
    assert_match "<li><b>DESCRIPTION</b> is too short (minimum is 10 characters)</li>", response.body
  end


  test "1.5 CATEGORY. should be able to reject a category with description shorter than 10 chars" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    @category[:description] = 'a'*9
    post categories_create_path, params: { category: @category }

    new_count = Category.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "Failed to create journal", response.body
    assert_match '<li><b>DESCRIPTION</b> is too short (minimum is 10 characters)</li>', response.body
  end


  test "1.6 CATEGORY. should be able to reject a category with description greater than 100 chars" do
    get categories_new_path
    assert_response :success
    old_count = Category.where(user_id: users(:user_one).id).count

    @category[:description] = 'a'*101
    post categories_create_path, params: { category: @category }

    new_count = Category.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "Failed to create journal", response.body
    assert_match '<li><b>DESCRIPTION</b> is too long (maximum is 100 characters)</li>', response.body
  end


  test "2.1 CATEGORY. should be able to show a category and tasks associated to it" do
    category = generate_category('1', users(:user_one).id)
    self.generate_task_times(10, category.id, users(:user_one).id)
    
    get tasks_path(category.id)
    assert_response :success

    tasks_count = controller.instance_variable_get(:@tasks).length

    task_cards_count = css_select('.tile-item').length
    assert tasks_count == task_cards_count
  end


  test "2.2 CATEGORY. should be able to reject GET requests to categories that current user doesn't own" do
    category = generate_category('1', users(:user_one).id)
    self.generate_task_times(10, category.id, users(:user_one).id)
    self.login_hacker

    get tasks_path(category.id)
    assert_redirected_to root_path
    follow_redirect!
    assert_match "Unauthorized action", response.body
  end


  test "3.1 CATEGORY. should be able to update a category" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    patch categories_update_path(category.id), params: { category: @category }
    assert_redirected_to home_dashboard_path
    follow_redirect!

    updated_category = Category.find(category.id)
    assert updated_category.name == @category[:name]
    assert updated_category.description == @category[:description]
    assert_match "Successfully updated your journal", response.body
  end


  test "3.2 CATEGORY. should be able to reject a category update for empty name" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    @category[:name] = ''
    patch categories_update_path(category.id), params: { category: @category }

    updated_category = Category.find(category.id)
    assert_not updated_category.name == @category[:name]
    assert_match "<li><b>NAME</b> can&#39;t be blank</li>", response.body
  end


  test "3.3 CATEGORY. should be able to reject a category update for name chars greater than 20" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    @category[:name] = 'a'*21
    patch categories_update_path(category.id), params: { category: @category }

    updated_category = Category.find(category.id)
    assert_not updated_category.name == @category[:name]
    assert_match "<li><b>NAME</b> is too long (maximum is 20 characters)</li>", response.body
  end


  test "3.4 CATEGORY. should be able to reject a category update for empty description" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    @category[:description] = ''
    patch categories_update_path(category.id), params: { category: @category }

    updated_category = Category.find(category.id)
    assert_not updated_category.description == @category[:description]
    assert_match "<li><b>DESCRIPTION</b> is too short (minimum is 10 characters)</li>", response.body
  end


  test "3.5 CATEGORY. should be able to reject a category update for empty description shorter than 10 chars" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    @category[:description] = 'a'*9
    patch categories_update_path(category.id), params: { category: @category }

    updated_category = Category.find(category.id)
    assert_not updated_category.description == @category[:description]
    assert_match "<li><b>DESCRIPTION</b> is too short (minimum is 10 characters)</li>", response.body
  end


  test "3.6 CATEGORY. should be able to reject a category update for empty description greater than 100 chars" do
    category = generate_category('1', users(:user_one).id)

    get categories_edit_path(category.id)
    assert_response :success

    @category[:description] = 'a'*101
    patch categories_update_path(category.id), params: { category: @category }

    updated_category = Category.find(category.id)
    assert_not updated_category.description == @category[:description]
    assert_match "<li><b>DESCRIPTION</b> is too long (maximum is 100 characters)</li>", response.body
  end

end
