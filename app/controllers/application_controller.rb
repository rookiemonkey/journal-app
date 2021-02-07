class ApplicationController < ActionController::Base

  include Exceptions::JournalErrors
  rescue_from CreateError, with: :create_journal_error
  rescue_from UpdateError, with: :update_journal_error


  protected

  def create_journal_error(exception)
    flash.now[:alert] = exception.message
    render 'category/new'
  end

  def update_journal_error(exception)
    flash.now[:alert] = exception.message
    render 'category/edit'
  end






  private

  def handler
    "#{params[:controller]}##{params[:action]}"
  end

end
