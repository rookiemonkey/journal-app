require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  
  def setup
    @category = Category.new(name: "Category One", description: ('a'*20))
  end

  test "1. should reject a category without a name" do
    @category.name = ''
    assert_not @category.valid?
  end

  test "2. should reject a category with a name that is longer than 20 chars" do
    @category.name = 'a' * 21
    assert_not @category.valid?
  end

  test "3. should reject a category without a description" do
    @category.description = ''
    assert_not @category.valid?
  end

  test "4. should reject a category with a description length less than 10" do
    @category.description = 'a' * 9
    assert_not @category.valid?
  end

  test "5. should reject a category with a description length greater than 100" do
    @category.description = 'a' * 101
    assert_not @category.valid?
  end

  test "6. should reject a category with the same name" do
    @category.save
    new_category = Category.new(name: "Category One", description: ('a'*20))
    assert_not new_category.valid?
  end

end
