class CreateCategoryTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :category_tasks, id: :uuid do |t|
      t.string :category_id
      t.string :task_id
    end
  end
end
