class ApplicationController < ActionController::Base

  include Exceptions::JournalErrors
  rescue_from ActiveRecord::RecordNotFound, with: :notfound_error
  rescue_from CreateJournalError,           with: :create_journal_error
  rescue_from UpdateJournalError,           with: :update_journal_error
  rescue_from CreateJournalTaskError,       with: :create_journal_task_error
  rescue_from CreateTaskError,              with: :create_task_error
  rescue_from UpdateTaskError,              with: :update_task_error
  rescue_from UnauthorizedError,            with: :unauthorize_error

  protect_from_forgery                      with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?


  
  def redirect_if_not_loggedin
    redirect_to(new_user_session_path, { alert: 'Please sign in first' })  unless user_signed_in?
  end



  protected  

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

  def notfound_error(exception)
    redirect_to root_path, alert: "Oh snap! That one doesn't exists"
  end

  def create_journal_error
    flash.now[:alert] = 'Failed to create journal'
    render 'category/new'
  end

  def create_journal_task_error
    flash.now[:alert] = 'Failed to create task'
    render 'home/new_task'
  end

  def update_journal_error
    flash.now[:alert] = 'Failed to update journal'
    render 'category/edit'
  end

  def create_task_error
    flash.now[:alert] = 'Failed to create task'
    render 'task/new'
  end

  def update_task_error
    flash.now[:alert] = 'Failed to update task'
    render 'task/edit'
  end

  def unauthorize_error
    redirect_to root_path, alert: "Unauthorized action"
  end

end
