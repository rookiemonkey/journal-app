class AddCategoryidToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :category_id, :string
  end
end
