ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def destroy_nils(model, prop)
    model.where("#{prop}" => nil).each { |u| u.destroy }
  end

  def login_hacker
    sign_out :user
    sign_in users(:user_two)
  end

  def generate_category(name, userid)
    Category.create(name: "Category #{name}", 
                    description: ('a'*20),
                    user_id: userid)
  end

  def generate_task(name, userid)
    now = Time.now
    category = self.generate_category(name, userid)

    Task.create(name: "Task #{name}", 
                description: "<p>#{('a'*20)}</p>",
                deadline: "#{now.year}-#{now.month}-#{now.day}",
                user_id: category.user_id,
                category_id: category.id)
  end

  def setup_statistics
    self.destroy_nils(Task, 'name')
    self.destroy_nils(Category, 'name')
    self.generate_task('for_another', users(:user_two).id)
    self.generate_task('for_another', users(:user_two).id)
    self.generate_task('for_another', users(:user_two).id)
    self.generate_task('11', users(:user_one).id)
    self.generate_task('10', users(:user_one).id)
    self.generate_task('9', users(:user_one).id)
    self.generate_task('8', users(:user_one).id)
    self.generate_task('7', users(:user_one).id)
    self.generate_task('6', users(:user_one).id)
    self.generate_task('5', users(:user_one).id)
    self.generate_task('4', users(:user_one).id)
    self.generate_task('3', users(:user_one).id)
    self.generate_task('2', users(:user_one).id)
    task_one = self.generate_task('1', users(:user_one).id)
    task_one.update(completed: true)
  end

  def generate_task_times(num, categoryid, userid)
    now = Time.now

    num.times do |n|
      Task.create(name: "Task #{n}", 
                  description: "<p>#{('a'*20)}</p>",
                  deadline: "#{now.year}-#{now.month}-#{now.day}",
                  user_id: userid,
                  category_id: categoryid)
    end
  end
  
end
