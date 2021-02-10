ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def destroy_nils(model, prop)
    model.where("#{prop}" => nil).each { |u| u.destroy }
  end
end
