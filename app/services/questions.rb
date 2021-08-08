require 'nokogiri'
require 'open-uri'
require 'byebug'

url = "https://bestlifeonline.com/the-meaning-of-life-and-27-other-major-unanswered-questions-in-science/"

data = Nokogiri::HTML(open(url))

questions = data.css('.number-head-mod-standalone')

File.open('db/questions.txt', 'w') do |file|
  questions.each do |question|
    title = question.at_css('.title')
    file.puts title.at_css('span').text
  end
end