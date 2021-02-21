# frozen_string_literal: true

json.extract! answer, :id, :chosen, :content, :created_at, :updated_at
json.url answer_url(answer, format: :json)
