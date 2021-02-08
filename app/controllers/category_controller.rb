class CategoryController < ApplicationController

  before_action :set_category, only: [:delete, :edit, :update]

  def index
    @categories = Category.all
    @tasks = Task.where('deadline <= ?', Date.today)
  end

  def new
  end

  def new_task
  end

  def edit
  end

  def create
    category = Category.create(self.extract_params)
    raise CreateJournalError.new('Failed to create journal') unless category.valid?
    redirect_to(categories_path, notice: 'Successfully created your journal')
  end

  def create_task
    @task = Task.create(self.extract_params_task)
    raise CreateJournalTaskError.new('Failed to create task') unless @task.valid?
    redirect_to(categories_path, notice: 'Successfully created a task')
  end

  def update
    @category.update(self.extract_params)
    raise UpdateJournalError.new('Failed to update journal') unless @category.valid?
    redirect_to(categories_path, notice: 'Successfully updated your journal')
  end

  def delete
    @category.destroy
    redirect_to(categories_path, notice: 'Successfully deleted your journal')
  end



  private

  def set_category
    @category = Category.find params[:id]
  end

  def extract_params
    params.require(:category).permit(:name, :description)
  end

  def extract_params_task
    params.require(:task).permit(:name, :description, :category_id, :deadline)
  end

end
