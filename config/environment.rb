# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# remove field_with_errors wrapper for validation errors
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end