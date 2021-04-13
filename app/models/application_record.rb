# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_destroy do
    throw :abort if invalid?(:destroy)
  end
end
