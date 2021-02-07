class CreateCategoryTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :category_tasks do |t|
      t.integer :category_id
      t.integer :task_id
    end
  end
end
