# frozen_string_literal: true

class TaskReflex < ApplicationReflex

  def complete(tid)
    task = Task.find(element.dataset[:tid])
    task.update(completed: !task.completed)
  end

  def delete(tid)
    task = Task.find(tid)
    task.destroy
  end
  
end
