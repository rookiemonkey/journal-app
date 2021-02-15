class TaskController < ApplicationController

  before_action :redirect_if_not_loggedin
  before_action :set_category, only: [:index, :new, :create, :delete, :update, :edit]
  before_action :set_task, only: [:edit, :delete, :update, :show]
  before_action :is_owner_of_category?, only: [:index, :new, :create, :edit, :update, :delete]
  before_action :is_owner_of_task?, only: [:edit, :delete, :update, :show]

  def index
    @tasks = @category.tasks
    @count_completed = @tasks.count { |t| t.completed }
    @count_not_completed = @tasks.count { |t| !t.completed }
  end

  def new
  end

  def edit
  end

  def show
    @category_name = @task.category.name
  end
  
  def create
    @task = Task.new(extract_params)
    @task.category_id = @category.id
    @task.user_id = current_user.id
    raise CreateTaskError unless @task.save
    redirect_to(tasks_path(@category.id), 
                notice: "Successfully created a task for #{@category.name}")
  end

  def update
    raise UpdateTaskError unless @task.update(extract_params)
    redirect_to(tasks_path(@category.id), 
                notice: "Successfully updated a task for #{@category.name}")
  end

  def delete
    @task.destroy
    redirect_to(tasks_path(@category.id), 
                notice: "Successfully deleted a task for #{@category.name}")
  end


  private

  def set_category
    @category = Category.find params[:id]
    raise ActiveRecord::RecordNotFound unless @category.id == params[:id]
  end

  def set_task  
    raise nil if params[:tid] == 'favicon'
    @task = Task.find params[:tid]
  end

  def extract_params
    params.require(:task).permit(:name, :description, :deadline)
  end

  def is_owner_of_category?
    raise UnauthorizedError unless current_user.id == @category.user_id
  end

  def is_owner_of_task?
    raise UnauthorizedError unless current_user.id == @task.user_id
  end

end
