# frozen_string_literal: true

def create_answer(question)
  Answer.create(
    body: Faker::Lorem.paragraph_by_chars(number: rand(100..200), supplemental: false),
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
      content: Faker::Lorem.question(word_count: rand(15..25), supplemental: true)
    )
  )
end

puts 'Atributing user to questions...'
questions.each do |question|
  question.user_id = @user.id
  rand(1..5).times { create_answer(question) }
  question.save!
end
