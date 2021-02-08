# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)







# CATEGORY CREATION

categories = ['Groceries', 'Church', 'Work', 'Chores', 'Code', 'School']

categories.each do |category|

  Category.create(  name: category, 
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quam risus, lacinia et luctus id, port")

end






# TASKS CREATION
# NOTE: did not include jan & feb since its already pastdated

year = ['2021', '2022']
month = ['03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
day = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

Category.all.each do |category|
  10.times do |i|
    deadline = ''
    deadline << year.sample
    deadline << "-#{month.sample}"
    deadline << "-#{day.sample}"

    task = Task.new(name: "#{category.name} #{i+1}",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quam risus, lacinia et luctus id, port",
                    deadline: deadline)

    task.category_id = category.id
    task.save
  end
end