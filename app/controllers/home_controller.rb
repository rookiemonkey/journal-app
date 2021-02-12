class HomeController < ApplicationController

  before_action :redirect_if_not_loggedin, except: [:index]

  def index
  end

  def new_task
    redirect_to(categories_new_path, alert: "Please create a journal first") if current_user.categories.length.zero?
  end

  def create_task
    @task = Task.create(self.extract_params_task)
    @task.user_id = current_user.id
    raise CreateJournalTaskError unless @task.save
    redirect_to(home_dashboard_path,  
                notice: 'Successfully created a task')
  end

  def dashboard
    @categories = Category.where(user_id: current_user.id)
    @tasks = Task.near_deadline.where(user_id: current_user.id)
    @statistics = statistics(@categories)
  end


  private

  def extract_params_task
    params.require(:task).permit(:name, :description, :category_id, :deadline)
  end


  def statistics(category_array)
    count = { completed: 0, not_completed: 0 }
    categories = Hash.new

    category_array.each do |category|
      category_statistics = { category_id: category.id, completed: 0, not_completed: 0 }

      category.tasks.each do |task|
        if task.completed
          count[:completed] += 1
          category_statistics[:completed] += 1
        end

        unless task.completed
          count[:not_completed] += 1
          category_statistics[:not_completed] += 1
        end
      end

      categories[category.id] = category_statistics
    end

    { count: count, categories: categories }
  end

end
