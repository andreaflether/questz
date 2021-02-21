# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    chosen { false }
    content { 'MyText' }
  end
end
