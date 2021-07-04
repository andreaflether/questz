# frozen_string_literal: true

puts 'Creating tags...'
file = File.open('db/tags.txt')

file.read.split('|').each do |tag|
  Tag.find_or_create_by(name: tag.strip)
end

if !Rails.env.production?
  def create_answer(question)
    Answer.create(
      body: Faker::Lorem.paragraph_by_chars(number: rand(100..200), supplemental: true),
      question: question,
      user: @user_answer
    )
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
