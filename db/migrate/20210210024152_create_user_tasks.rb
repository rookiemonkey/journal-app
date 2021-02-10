class CreateUserTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tasks do |t|
      t.integer :user_id
      t.integer :task_id
    end
  end
end
