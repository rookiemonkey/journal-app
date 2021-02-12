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
    @tasks = Task.where('deadline <= ? and user_id = ?', 
                        Date.today, 
                        current_user.id)
  end


  private

  def extract_params_task
    params.require(:task).permit(:name, :description, :category_id, :deadline)
  end

end
