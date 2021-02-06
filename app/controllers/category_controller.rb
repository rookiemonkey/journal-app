require "pp"

class CategoryController < ApplicationController

  before_action :set_category, only: [:show, :delete]

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
    render :new unless @category.valid?
    redirect_to categories_show_path(@category) if @category.valid?
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
    params.require(:category).permit(:name)
  end

end
