class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
