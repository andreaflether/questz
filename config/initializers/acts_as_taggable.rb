# frozen_string_literal: true

module Questz
  class Application < Rails::Application
    # Force tags to be saved downcased
    ActsAsTaggableOn.force_lowercase = true

    # Save tags parametrized
    ActsAsTaggableOn.force_parameterize = true

    # Remove unused tag objects after removing taggings
    # ActsAsTaggableOn.remove_unused_tags = true
  end
end

ActsAsTaggableOn::Tag.class_eval do
  acts_as_url :name, url_attribute: :slug, sync_url: true, limit: 80

  def to_param
    slug
  end
end
