class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :deadline
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
