# frozen_string_literal: true

class CategoryReflex < ApplicationReflex

  def delete(id)
    task = Category.find(id.to_i)
    task.destroy
  end
  
end
