# frozen_string_literal: true

json.results(@questions) do |question|
  json.id question.id
  json.text question.title
end
