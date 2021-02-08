class TaskController < ApplicationController

  before_action :set_category, only: [:index, :create]
  before_action :set_task, only: [:edit, :delete, :update, :show]

  def index
  end

  def new
  end

  def edit
  end
  
  def create
    @task = Task.new(self.extract_params)
    @task.category_id = @category.id
    raise CreateTaskError.new('Failed to create task') unless @task.save
    redirect_to tasks_path(@task.category_id)
  end

  def update
    raise UpdateTaskError.new('Failed to update task') unless @task.update(self.extract_params)
    redirect_to tasks_path(@task.category_id)
  end

  def delete
    @task.destroy
  end


  private

  def set_category
    @category = Category.find params[:id]
  end

  def set_task
    @task = Task.find params[:tid]
  end

  def extract_params
    params.require(:task).permit(:name, :description, :deadline)
  end

end
