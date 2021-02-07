require "test_helper"
require "pp"

class CategoryTaskTest < ActiveSupport::TestCase

  def setup
    @task = Task.create(name: "Task One")
    @category = Category.create(name: "Category One", description: ('a'*20))
  end

  test "task should reject if not associated to any category" do
    assert_not @task.valid?
  end

  test "task should be able to associate against a category" do
    @task.category_id = @category.id
    @category.tasks << @task
    assert @category.tasks.length == 1
  end

  test "task should be able to delete all tasks associated to a category" do

    self.destroy_nils(Task, 'name')
    self.destroy_nils(Category, 'name')
    task_two = Task.create(name: "Task Two")
    task_three = Task.create(name: "Task Three")

    @task.category_id = @category.id
    task_two.category_id = @category.id
    task_three.category_id = @category.id

    @task.save
    task_two.save
    task_three.save

    @category.tasks << @task
    @category.tasks << task_two
    @category.tasks << task_three
    @category.save

    @category.destroy

    assert Task.all.length == 0
  end

end
