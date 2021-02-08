class ApplicationController < ActionController::Base

  include Exceptions::JournalErrors
  rescue_from ActiveRecord::RecordNotFound, with: :notfound_error
  rescue_from CreateJournalError, with: :create_journal_error
  rescue_from UpdateJournalError, with: :update_journal_error
  rescue_from CreateTaskError, with: :create_task_error
  rescue_from UpdateTaskError, with: :update_task_error


  protected  

  def notfound_error(exception)
    redirect_to categories_path, alert: "Oh snap! That one doesn't exists"
  end

  def create_journal_error(exception)
    flash.now[:alert] = exception.message
    render 'category/new'
  end

  def update_journal_error(exception)
    flash.now[:alert] = exception.message
    render 'category/edit'
  end

  def create_task_error(exception)
    flash.now[:alert] = exception.message
    render 'task/new'
  end

  def update_task_error(exception)
    flash.now[:alert] = exception.message
    render 'task/edit'
  end

end
