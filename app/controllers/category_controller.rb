require "pp"

class CategoryController < ApplicationController

  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
  end

  def new
  end

  def edit
  end

  def show
  end

  def delete
  end


  private

  def set_category
    @category = Category.find params[:id]
  end

end
