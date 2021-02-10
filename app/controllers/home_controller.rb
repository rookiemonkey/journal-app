class HomeController < ApplicationController

  before_action :redirect_if_not_loggedin

  def new_task
  end

  def create_task
    @task = Task.create(self.extract_params_task)
    @task.user_id = current_user.id
    raise CreateJournalTaskError.new('Failed to create task') unless @task.save
    redirect_to(root_path, notice: 'Successfully created a task')
  end

  def home
    @categories = Category.where(user_id: current_user.id)
    @tasks = Task.where('deadline <= ? and user_id = ?', Date.today, current_user.id)
  end


  private

  def extract_params_task
    params.require(:task).permit(:name, :description, :category_id, :deadline)
  end

end
