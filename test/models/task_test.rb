require "test_helper"
require "pp"

class TaskTest < ActiveSupport::TestCase

  def setup
    category = Category.create(name: "Category One", 
                              description: ("a"*50))

    @task = Task.create(name: "Task One", 
                        description: ("a"*50), 
                        deadline: "2021-03-30", 
                        category_id: category.id)
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

  test "5. task should reject description with 150 chars and more" do
    @task.description = 'a'*151
    assert_not @task.valid?
  end

  test "6. task should reject empty deadline" do
    @task.deadline = ''
    assert_not @task.valid?
  end

  test "8. task should reject past dated deadline" do
    @task.deadline = '2021-02-07'
    assert_not @task.valid?
  end

  test "9. task should accept dated deadline today" do
    time_now = Time.now
    deadline = ''
    deadline << time_now.year
    deadline << "-#{time_now.month}"
    deadline << "-#{time_now.day}"
    @task.deadline = deadline
    assert_not @task.valid?
  end

end
