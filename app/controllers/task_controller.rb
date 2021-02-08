class TaskController < ApplicationController

  before_action :set_category, only: [:index]
  before_action :set_task, only: [:edit]

  def index
  end

  def new
  end

  def edit
  end

  def create
  end


  private

  def set_category
    @category = Category.find params[:id]
  end

  def set_task
    @task = Task.find params[:tid]
  end

end
