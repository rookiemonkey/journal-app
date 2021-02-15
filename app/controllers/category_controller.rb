class CategoryController < ApplicationController

  before_action :redirect_if_not_loggedin
  before_action :set_category, only: [:delete, :edit, :update]
  before_action :is_owner_of_category?, only: [:delete, :edit, :update]

  def new
  end

  def edit
  end

  def create
    @category = Category.create(extract_params)
    @category.user_id = current_user.id
    raise CreateJournalError unless @category.save
    redirect_to(home_dashboard_path, 
                notice: 'Successfully created your journal')
  end

  def update
    raise UpdateJournalError unless @category.update(extract_params)
    redirect_to(home_dashboard_path,
                notice: 'Successfully updated your journal')
  end

  def delete
    @category.destroy
    redirect_to(home_dashboard_path, 
                notice: 'Successfully deleted your journal')
  end



  private

  def set_category
    @category = Category.find params[:id]
    raise ActiveRecord::RecordNotFound unless @category.id == params[:id]
  end

  def extract_params
    params.require(:category).permit(:name, :description)
  end

  def is_owner_of_category?
    raise UnauthorizedError unless current_user.id == @category.user_id
  end

end
