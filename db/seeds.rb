# frozen_string_literal: true

puts 'Creating tags...'
file = File.open('db/tags.txt')

file.read.split('|').each do |tag|
  Tag.find_or_create_by(name: tag.strip)
end

puts 'Creating default users...'
@user = User.create_with(
  name: 'User',
  password: 'user@123',
  username: 'user'
).find_or_create_by(email: 'user@user.com')

@user_answer = User.create_with(
  name: 'Another user',
  password: 'anotheruser@123',
  username: 'another_user'
).find_or_create_by(email: 'another.user@user.com')

def create_answer(question)
  Answer.create(
    body: Faker::Lorem.paragraph_by_chars(number: rand(100..200), supplemental: true),
    question: question,
    user: @user_answer
  )
end

puts 'Creating questions...'
questions = File.open('db/questions.txt').read

questions.each_line do |question|
  title, body = question.split('|')
  Question.create(
    title: title,
    body: body.strip,
    user: @user,
    tag_list: 'science'
  )
end

puts 'Adding answers to questions...'
Question.all.each do |question|
  rand(1..5).times { create_answer(question) }
end

if !Rails.env.production?
  puts 'Creating mod user...'
  @mod = User.create_with(
    name: 'Moderator',
    password: 'mod@1234',
    username: 'moderator'
  ).find_or_create_by(email: 'mod@mod.com')

  puts 'Creating admin user...'
  @admin = User.create_with(
    name: 'Admin',
    password: 'admin@123',
    username: 'admin_user'
  ).find_or_create_by(email: 'admin@admin.com')

  @mod.mod!
  @admin.adm!

  puts 'Instantiating questions...'
  questions = []

  rand(5..10).times do
    questions.push(
      Question.create(
        title: Faker::Lorem.question(word_count: 15, supplemental: true),
        body: Faker::Lorem.paragraph_by_chars(number: rand(150..300), supplemental: true),
        tag_list: Tag.all.sample,
        user: @user
      )
    )
  end

  puts 'Adding answers to questions...'
  questions.each do |question|
    rand(1..5).times { create_answer(question) }
  end
end