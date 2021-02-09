class CategoryController < ApplicationController

  before_action :set_category, only: [:delete, :edit, :update]

  def new
  end

  def edit
  end

  def create
    @category = Category.create(self.extract_params)
    raise CreateJournalError.new('Failed to create journal') unless @category.valid?
    redirect_to(root_path, notice: 'Successfully created your journal')
  end

  def update
    @category.update(self.extract_params)
    raise UpdateJournalError.new('Failed to update journal') unless @category.valid?
    redirect_to(root_path, notice: 'Successfully updated your journal')
  end

  def delete
    @category.destroy
    redirect_to(root_path, notice: 'Successfully deleted your journal')
  end



  private

  def set_category
    @category = Category.find params[:id]
  end

  def extract_params
    params.require(:category).permit(:name, :description)
  end

end
