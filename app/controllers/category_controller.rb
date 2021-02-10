class CategoryController < ApplicationController

  before_action :redirect_if_not_loggedin
  before_action :set_category, only: [:delete, :edit, :update]

  def new
  end

  def edit
    raise UnauthorizedError unless self.is_owner?
  end

  def create
    @category = Category.create(self.extract_params)
    @category.user_id = current_user.id
    raise CreateJournalError unless @category.save
    redirect_to(root_path, 
                notice: 'Successfully created your journal')
  end

  def update
    raise UnauthorizedError unless self.is_owner?
    raise UpdateJournalError unless @category.update(self.extract_params)
    redirect_to(root_path,
                notice: 'Successfully updated your journal')
  end

  def delete
    raise UnauthorizedError unless self.is_owner?
    @category.destroy
    redirect_to(root_path, 
                notice: 'Successfully deleted your journal')
  end



  private

  def set_category
    @category = Category.find params[:id]
  end

  def extract_params
    params.require(:category).permit(:name, :description)
  end

  def is_owner?
    current_user.id == @category.user_id
  end

end
