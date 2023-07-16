# frozen_string_literal: true

module AnswersHelper
  def get_filtered_content(answer)
    answer_body = answer.body

    matched = @filters.matched(answer_body)
    replace_words(matched, 'forbidden-word', answer_body)

    answer.has_restricted_word = true if matched.any?

    answer_body
  end

  def create_span_for_word(content, css_classes)
    tag.span(content.html_safe, class: css_classes)
  end

  def replace_words(collection, classes, content)
    collection.each { |w| content.gsub!(w, create_span_for_word(w, classes)) }
  end
end
