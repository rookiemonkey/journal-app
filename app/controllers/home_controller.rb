class HomeController < ApplicationController

  def home
    @categories = Category.all
    @tasks = Task.where('deadline <= ?', Date.today)
  end

end
