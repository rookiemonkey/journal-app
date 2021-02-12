require "test_helper"

class TaskTest < ActiveSupport::TestCase

  def setup
    @category = Category.create(name: "Category One", 
                              description: ("a"*50),
                              user_id: users(:user_one).id)

    now = Time.now

    @task = Task.create(name: "Task One", 
                        description: ("a"*50), 
                        deadline: "#{now.year}-#{now.month}-#{now.day}", 
                        category_id: @category.id,
                        user_id: users(:user_one).id)
  end

  
  test "1. task should reject empty name" do
    @task.name = ''
    assert_not @task.valid?
  end


  test "2. task should reject name with 20 chars and more" do
    @task.name = '1'*21
    assert_not @task.valid?
  end


  test "3. task should be complete false upon creation" do
    assert_not @task.completed
  end


  test "4. task should reject empty description" do
    @task.description = ''
    assert_not @task.valid?
  end


  test "5. task should reject description with 2500 chars and more" do
    @task.description = 'a'*2501
    assert_not @task.valid?
  end


  test "6. task should reject empty deadline" do
    @task.deadline = ''
    assert_not @task.valid?
  end


  test "8. task should reject past dated deadline for new records" do
    now = Time.now

    task = Task.create(name: "Task One", 
                        description: ("a"*50), 
                        deadline: "#{now.year-1}-#{now.month}-#{now.day}", 
                        category_id: @category.id,
                        user_id: users(:user_one).id)

    assert_not task.valid?
  end


  test "10. task should reject past dated deadline for old records only if deadline is changed" do
    now = Time.now
    @task.deadline = "#{now.year-1}-#{now.month}-#{now.day}"
    @task.save
    assert_not @task.valid?
  end


  test "11. task should accept past dated deadline for old records only if deadline is not changed" do
    @task.name = "Did not updated"
    @task.description = "This should be a ok on the model layer"
    @task.save
    assert @task.valid?
  end


  test "12. task should accept past dated deadline for old records only if deadline is not changed (pt2)" do
    @task.completed = true
    @task.save
    assert @task.valid?
  end


  test "12. task should accept past dated deadline for old records only if deadline is not changed (pt3)" do
    @task.completed = true
    @task.save
    @task.completed = false
    @task.save
    assert @task.valid?
  end


  test "13. task should accept dated deadline today" do
    time_now = Time.now
    deadline = ''
    deadline << time_now.year
    deadline << "-#{time_now.month}"
    deadline << "-#{time_now.day}"
    @task.deadline = deadline
    assert @task.valid?
  end

end
