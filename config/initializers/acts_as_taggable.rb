# frozen_string_literal: true

module Questz
  class Application < Rails::Application
    # Force tags to be saved downcased
    ActsAsTaggableOn.force_lowercase = true

    # Save tags parametrized
    ActsAsTaggableOn.force_parameterize = true

    # Remove unused tag objects after removing taggings
    ActsAsTaggableOn.remove_unused_tags = true
  end
end
