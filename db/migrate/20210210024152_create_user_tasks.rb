class CreateUserTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tasks do |t|
      t.string :user_id
      t.string :task_id
    end
  end
end
