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


  test "2.9 TASK. should be able to update a task on nested route" do
    now = Time.now
    task = self.save_task

    @task[:name] = 'Updated Name!'
    @task[:description] = '<p>Updated Description</p>'
    @task[:deadline] = "#{now.year}-#{now.month}-#{now.day}"

    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }
    assert_redirected_to tasks_path(task.category_id)

    follow_redirect!
    assert_match "Successfully updated a task for Category 1", response.body

    task_on_db = Task.find task.id
    assert task_on_db.name == 'Updated Name!'
    assert task_on_db.deadline == "#{now.year}-#{now.month}-#{now.day}"
    assert task_on_db.description.to_s == "<div class=\"trix-content\">\n" +
                                          "  <p>Updated Description</p>\n" +
                                          "</div>\n"
  end


  test "2.10 TASK. should be able to reject task update on nested route if name is empty" do
    task = self.save_task

    @task[:name] = ''
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.name == ''
    assert_match "<li><b>NAME</b> can&#39;t be blank</li>", response.body
  end


  test "2.11 TASK. should be able to reject task update on nested route if name is greater than 20 chars" do
    task = self.save_task

    @task[:name] = 'a'*21

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.name == 'a'*21
    assert_match "<li><b>NAME</b> is too long (maximum is 20 characters)</li>", response.body
  end


  test "2.12 TASK. should be able to reject task update on nested route if description is empty" do
    task = self.save_task

    @task[:description] = ''
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.description == ''
    assert_match "<li><b>DESCRIPTION</b> can&#39;t be blank</li>", response.body
  end


  test "2.13 TASK. should be able to reject task update on nested route if description is greater than 2500" do
    task = self.save_task

    @task[:description] = ''
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.description == ''
    assert_match "<li><b>DESCRIPTION</b> can&#39;t be blank</li>", response.body
  end


  test "2.14 TASK. should be able to reject task update on nested route if deadline is empty" do
    task = self.save_task

    @task[:deadline] = ''
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.deadline == ''
    assert_match "<li><b>DEADLINE</b> can&#39;t be blank</li>", response.body
  end


  test "2.15 TASK. should be able to reject task update on nested route if deadline is past" do
    task = self.save_task

    @task[:deadline] = '1999-01-01'
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    task_on_db = Task.find task.id
    assert_not task_on_db.deadline == '1999-01-01'
    assert_match "<li><b>DEADLINE</b> is already past</li>", response.body
  end


  test "2.16 TASK. should be able to accept task update on nested route if deadline is future" do
    task = self.save_task

    now = Time.now
    @task[:deadline] = "#{now.year}-#{now.month}-#{now.day+1}"
    get tasks_edit_path(id: task.category_id, tid: task.id)
    assert_response :success

    patch tasks_update_path(id: task.category_id, tid: task.id), params: { task: @task }

    follow_redirect!
    task_on_db = Task.find task.id
    assert task_on_db.deadline == "#{now.year}-#{now.month}-#{now.day+1}"
    assert_match "Successfully updated a task", response.body
  end
  








  private

  def remove_setup_category_id
    @task.reject! { |k, _| k == :category_id }
  end

  def save_task
    @task[:user_id] = users(:user_one).id
    Task.create(@task)
  end

end
