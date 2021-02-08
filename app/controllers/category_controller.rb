class CategoryController < ApplicationController

  before_action :set_category, only: [:delete, :edit, :update]

  def index
    @categories = Category.all
  end

  def new
  end

  def edit
  end

  def create
    @category = Category.create(self.extract_params)
    raise CreateJournalError.new('Failed to create journal') unless @category.valid?
    redirect_to(tasks_path(@category), notice: 'Successfully created your journal')
  end

  def update
    @category.update(self.extract_params)
    raise UpdateJournalError.new('Failed to update journal') unless @category.valid?
    redirect_to(tasks_path(@category), notice: 'Successfully updated your journal')
  end

  def delete
    @category.destroy
    redirect_to categories_path
  end



  private

  def set_category
    @category = Category.find params[:id]
  end

  def extract_params
    params.require(:category).permit(:name, :description)
  end

end
