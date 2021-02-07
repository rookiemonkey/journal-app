require "test_helper"
require "pp"

class TaskTest < ActiveSupport::TestCase

  def setup
    @task = Task.create(name: "Task One")
  end

  test "1. task should reject empty name" do
    @task.name = ''
    assert_not @task.valid?
  end

  test "2. task should reject name with 5 char and less" do
    @task.name = '1111'
    assert_not @task.valid?
  end

  test "3. task should reject name with 50 char and more" do
    @task.name = '1'*51
    assert_not @task.valid?
  end

  test "4. task should be complete false upon creation" do
    assert_not @task.completed
  end

end
