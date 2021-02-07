require "pp"

class CategoryController < ApplicationController

  before_action :set_category, only: [:show, :delete, :edit, :update]

  def index
    @categories = Category.all
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    @category = Category.create(self.extract_params)
    raise 'Failed to create journal' unless @category.valid?
    redirect_to(categories_show_path(@category), notice: 'Successfully created your journal')
  end

  def update
    @category.update(self.extract_params)

    unless @category.valid?
      flash.now[:alert] = 'Failed to update journal'
      return render :edit
    end

    redirect_to(categories_show_path(@category), notice: 'Successfully updated your journal')
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
