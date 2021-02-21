# frozen_string_literal: true

json.extract! question, :id, :status, :content, :created_at, :updated_at
json.url question_url(question, format: :json)
