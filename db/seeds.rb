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

task_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec ornare massa. In pharetra nibh vel purus commodo porta. Sed faucibus non risus eu mattis. Etiam sagittis ullamcorper arcu, venenatis suscipit odio consequat eget. Mauris sagittis felis lectus, vitae posuere dui semper ac. Cras hendrerit tempus mauris quis sollicitudin. Mauris sapien arcu, viverra ut semper ut, posuere quis libero. Mauris eu enim ex. Nullam volutpat orci ligula, ut euismod lorem viverra ut. Integer in bibendum dolor. Quisque dui dui, congue nec dolor blandit, pulvinar tincidunt ex. Etiam ornare augue tincidunt ipsum varius tempor. Aenean eget augue aliquam, mattis libero vitae, elementum lacus. Cras non enim maximus, pellentesque dui et, molestie enim. Pellentesque vehicula cursus nisi, sit amet laoreet erat fringilla a. Donec eu orci urna. Nam in nisl quis nunc imperdiet facilisis. Vestibulum finibus erat mauris, a sollicitudin mauris consectetur eget. Vestibulum vitae mauris eu dolor gravida ornare vel nec eros. Duis fringilla elit ac nisi faucibus, sit amet vulputate dolor tempus. Sed volutpat nunc at nisi consectetur, ut feugiat enim ullamcorper. Sed sollicitudin dolor sit amet lorem placerat, eget mollis ipsum rutrum. Quisque quis nisl commodo, vulputate risus vel, dapibus ipsum. Duis consectetur felis eu sem eleifend, sed ornare felis convallis. Aliquam non placerat odio, sit amet posuere magna. Phasellus at rhoncus mauris, a ultricies odio. Nam hendrerit erat ante, et ornare lacus convallis sit amet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum vehicula, risus ac scelerisque aliquet, lacus odio fermentum lorem, vehicula dapibus urna dui blandit ex. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nullam sit amet leo eu neque varius suscipit at aliquet eros. Donec venenatis condimentum venenatis. Nam ac maximus quam, non mattis ex. Etiam a risus tincidunt, molestie leo eget, interdum nibh. Morbi laoreet tortor eu dapibus dapibus. Donec quis massa turpis. In hac habitasse platea dictumst. Vivamus semper nunc et justo vulputate, at sodales lectus lacinia. Suspendisse efficitur mi et nulla vestibulum tincidunt vel et odio. Donec justo ligula, sollicitudin vitae augue tempus, luctus pretium ante. Donec vehicula dictum leo in condimentum. Aliquam eu varius massa. Etiam sagittis in mauris quis euismod. Ut sollicitudin ipsum dolor, id suscipit sem sollicitudin quis. quis."
month = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
day = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

Category.all.each do |category|
  now = Time.now

  # 10 task that has random deadline in the future
  10.times do |i|
    Task.create(name: "#{category.name} #{i+1}",
                    description: task_description,
                    deadline: "#{now.year+1}-#{month.sample}-#{day.sample}",
                    category_id: category.id,
                    user_id: user_one.id)
  end



  # have at least one task that is due today
  Task.create(name: "#{category.name} 11",
              description: task_description,
              deadline: "#{now.year}-#{now.month}-#{now.day}",
              category_id: category.id,
              user_id: user_one.id)
end