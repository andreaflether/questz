# frozen_string_literal: true

json.results(@tags) do |tag|
  json.id tag.id
  json.text tag.name
end
