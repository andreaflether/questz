# frozen_string_literal: true

json.extract! photo, :id, :created_at, :updated_at

json.url photo_url(photo, format: :json)
json.image_url photo.image.url
