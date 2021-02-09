class ApplicationController < ActionController::Base

  include Exceptions::JournalErrors
  rescue_from ActiveRecord::RecordNotFound, with: :notfound_error
  rescue_from CreateJournalError, with: :create_journal_error
  rescue_from UpdateJournalError, with: :update_journal_error
  rescue_from CreateJournalTaskError, with: :create_journal_task_error
  rescue_from CreateTaskError, with: :create_task_error
  rescue_from UpdateTaskError, with: :update_task_error

  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected  

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

  def notfound_error(exception)
    redirect_to root_path, alert: "Oh snap! That one doesn't exists"
  end

  def create_journal_error(exception)
    flash.now[:alert] = exception.message
    render 'category/new'
  end

  def create_journal_task_error(exception)
    flash.now[:alert] = exception.message
    render 'home/new_task'
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
