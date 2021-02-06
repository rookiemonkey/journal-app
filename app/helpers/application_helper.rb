module ApplicationHelper

  def date_full_words(date_object)
      date_object.strftime("%A, %d %b %Y")
  end

end
