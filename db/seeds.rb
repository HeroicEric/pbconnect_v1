require 'factory_girl'
require_relative '../spec/factories'

Rake::Task['db:reset'].invoke

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Eric Kelly', :email => 'heroiceric@gmail.com', :password => 'foobar', :password_confirmation => 'foobar'
puts 'New user created: ' << user.name

100.times do
  @user = Factory(
    :user,
    name: Faker::Name.name
  )
  puts "Adding user #{@user.name}"
  rand(15).times do
    @user.updates << Factory(
      :update,
      user: @user,
      content: Faker::Lorem.sentence(rand(10)+1),
      created_at: (time_rand Time.local(2010, 1, 1))
    )
  end
end

# Randomly make users follow each other
User.all.each do |user|
  puts "Adding follows for #{user.name}"
  (rand(10)+1).times do
    user.follow(User.find(rand(100)+1))
  end
end

5.times do
  @team = Factory(:team, name: Faker::Company.name)
  puts "Creating Team: #{@team.name}"
  (rand(6) + 5).times do
    member = User.not_on_team(@team)[rand(User.not_on_team(@team).count)]
    @team.add_member(member)
  end
end