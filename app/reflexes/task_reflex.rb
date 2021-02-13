# frozen_string_literal: true

class TaskReflex < ApplicationReflex

  def toggle_complete
    task = Task.find(element.dataset[:tid])
    task.update(completed: !task.completed)
  end
  
end
