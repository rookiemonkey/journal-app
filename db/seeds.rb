# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# USER CREATION

user_one = User.create(first_name: 'Kevin One',
            last_name: 'Basina',
            email: 'one@gmail.com',
            password: '987654321',
            encrypted_password: Devise::Encryptor.digest(User, '987654321'))

User.create(first_name: 'Kevin Two',
            last_name: 'Basina',
            email: 'two@gmail.com',
            password: '987654321',
            encrypted_password: Devise::Encryptor.digest(User, '987654321'))


# CATEGORY CREATION

categories = ['Groceries', 'Church', 'Work', 'Chores', 'Code', 'School']

categories.each do |category|

  Category.create(  name: category, 
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quam risus, lacinia et luctus id, port",
                    user_id: user_one.id)

end






# TASKS CREATION
# NOTE: did not include jan & feb since its already pastdated

month = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
day = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

Category.all.each do |category|
  now = Time.now

  # 10 task that has random deadline in the future
  10.times do |i|
    Task.create(name: "#{category.name} #{i+1}",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quam risus, lacinia et luctus id, port",
                    deadline: "#{now.year+1}-#{month.sample}-#{day.sample}",
                    category_id: category.id,
                    user_id: user_one.id)
  end



  # have at least one task that is due today
  Task.create(name: "#{category.name} 11",
              description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quam risus, lacinia et luctus id, port",
              deadline: "#{now.year}-#{now.month}-#{now.day}",
              category_id: category.id,
              user_id: user_one.id)
end