class ApplicationController < ActionController::Base

  rescue_from RuntimeError, with: :catch_runtime_errors


  protected

  def catch_runtime_errors(exception)
    flash.now[:alert] = exception.message
    render 'category/new' if handler == 'category#create'
  end







  private

  def handler
    "#{params[:controller]}##{params[:action]}"
  end

end
