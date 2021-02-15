class CreateUserCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_categories do |t|
      t.string :user_id
      t.string :category_id
    end
  end
end
