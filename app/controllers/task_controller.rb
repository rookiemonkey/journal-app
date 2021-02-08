require 'pp'

class TaskController < ApplicationController

  before_action :set_category, only: [:index, :create]
  before_action :set_task, only: [:edit, :delete, :update]

  def index
  end

  def new
  end

  def edit
  end

  def create
    @task = Task.new(self.extract_params)
    @task.category_id = @category.id
    @task.save
    @category.tasks << @task
    @category.save
  end

  def update
    @task.update(self.extract_params)
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
