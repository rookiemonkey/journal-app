require "test_helper"

class TaskFlowsTest < ActionDispatch::IntegrationTest

  def setup
    sign_in users(:user_one)
    @category = self.generate_category('1', users(:user_one).id)
    now = Time.now

    @task = {
      category_id: @category.id,
      name: 'Name',
      description: '<p>Description</p>',
      deadline: "#{now.year}-#{now.month}-#{now.day}"
    }
  end


  test "1.1 TASK. should be able to create a task on unnested route" do
    get home_new_task_path
    assert_response :success
    
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    new_task = Task.last

    assert_redirected_to home_dashboard_path
    follow_redirect!

    assert (new_count-old_count) == 1
    assert new_count > old_count
    assert_not new_task.completed
    assert_match "Successfully created a task", response.body
  end


  test "1.2 TASK. should be able to reject a task on unnested route if name is empty" do
    get home_new_task_path
    assert_response :success
    
    @task[:name] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>NAME</b> can&#39;t be blank</li>", response.body
  end


  test "1.3 TASK. should be able to reject a task on unnested route if name is greater than 20 chars" do
    get home_new_task_path
    assert_response :success
    
    @task[:name] = 'a'*21
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    
    assert new_count == old_count
    assert_match "<li><b>NAME</b> is too long (maximum is 20 characters)</li>", response.body
  end


  test "1.4 TASK. should be able to reject a task on unnested route if description is empty" do
    get home_new_task_path
    assert_response :success
    
    @task[:description] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count


    assert new_count == old_count
    assert_match "<li><b>DESCRIPTION</b> can&#39;t be blank</li>", response.body
  end


  test "1.5 TASK. should be able to reject a task on unnested route if description is greater than 2500 chars" do
    get home_new_task_path
    assert_response :success
    
    @task[:description] = '<p>H</p>'*2501
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>DESCRIPTION</b> is too long (maximum is 2500 characters)</li>", response.body
  end


  test "1.6 TASK. should be able to reject a task on unnested route if deadline is empty" do
    get home_new_task_path
    assert_response :success
    
    @task[:deadline] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>DEADLINE</b> can&#39;t be blank</li>", response.body
  end


  test "1.7 TASK. should be able to reject a task on unnested route if deadline is past" do
    get home_new_task_path
    assert_response :success
    
    @task[:deadline] = '2020-02-06'
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>DEADLINE</b> is already past</li>", response.body
  end
  

  test "1.8 TASK. should be able to accept a task on unnested route if deadline is today" do
    get home_new_task_path
    assert_response :success
    
    now = Time.now
    @task[:deadline] = "#{now.year}-#{now.month}-#{now.day}"
    old_count = Task.where(user_id: users(:user_one).id).count
    post home_create_task_path, params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    follow_redirect!    
    assert (new_count-old_count) == 1
    assert new_count > old_count
    assert_match "Successfully created a task", response.body
  end







  test "2.1 TASK. should be able to create a task on nested route" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    new_task = Task.last

    assert_redirected_to tasks_path(@category)
    follow_redirect!

    assert (new_count-old_count) == 1
    assert new_count > old_count
    assert_not new_task.completed
    assert_match "Successfully created a task", response.body
  end


  test "2.2 TASK. should be able to reject a task on nested route if name is empty" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:name] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>NAME</b> can&#39;t be blank</li>", response.body
  end


  test "2.3 TASK. should be able to reject a task on nested route if name is greater than 20 chars" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:name] = 'a'*21
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    
    assert new_count == old_count
    assert_match "<li><b>NAME</b> is too long (maximum is 20 characters)</li>", response.body
  end


  test "2.4 TASK. should be able to reject a task on nested route if description is empty" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:description] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>DESCRIPTION</b> can&#39;t be blank</li>", response.body
  end


  test "2.5 TASK. should be able to reject a task on nested route if description is greater than 2500 chars" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:description] = '<p>H</p>'*2501
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    
    assert new_count == old_count
    assert_match "<li><b>DESCRIPTION</b> is too long (maximum is 2500 characters)</li>", response.body
  end


  test "2.6 TASK. should be able to reject a task on nested route if deadline is empty" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:deadline] = ''
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    
    assert new_count == old_count
    assert_match "<li><b>DEADLINE</b> can&#39;t be blank</li>", response.body
  end

  test "2.7 TASK. should be able to reject a task on nested route if deadline is past" do
    get tasks_new_path(@category)
    assert_response :success
    
    self.remove_setup_category_id
    @task[:deadline] = '2020-02-02'
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count

    assert new_count == old_count
    assert_match "<li><b>DEADLINE</b> is already past</li>", response.body
  end


  test "2.8 TASK. should be able to accept a task on nested route if deadline is today" do
    get tasks_new_path(@category)
    assert_response :success
    
    now = Time.now
    self.remove_setup_category_id
    @task[:deadline] = "#{now.year}-#{now.month}-#{now.day}"
    old_count = Task.where(user_id: users(:user_one).id).count
    post tasks_create_path(@category), params: { task: @task }
    new_count = Task.where(user_id: users(:user_one).id).count
    
    follow_redirect!
    assert (new_count-old_count) == 1
    assert new_count > old_count
    assert_match "Successfully created a task", response.body
  end

  








  private

  def remove_setup_category_id
    @task.reject! { |k, _| k == :category_id }
  end

end
