# frozen_string_literal: true

module Questz
  class Application < Rails::Application
    # Force tags to be saved downcased
    ActsAsTaggableOn.force_lowercase = true

    # Save tags parametrized
    ActsAsTaggableOn.force_parameterize = true
  end
end
