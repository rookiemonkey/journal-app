class HomeController < ApplicationController

  before_action :redirect_if_not_loggedin

  def new_task
  end

  def create_task
    @task = Task.create(self.extract_params_task)
    raise CreateJournalTaskError.new('Failed to create task') unless @task.valid?
    redirect_to(root_path, notice: 'Successfully created a task')
  end

  def home
    @categories = Category.all
    @tasks = Task.where('deadline <= ?', Date.today)
  end


  private

  def extract_params_task
    params.require(:task).permit(:name, :description, :category_id, :deadline)
  end

end
