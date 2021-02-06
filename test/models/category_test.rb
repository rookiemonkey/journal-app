require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  
  def setup
    @category = Category.new
  end

  test "1. should reject a category without a name" do
    @category.name = ''
    assert_not @category.save
  end

  test "2. should reject a category with a name that is longer than 20 chars" do
    @category.name = 'a' * 21
    assert_not @category.save
  end

end
