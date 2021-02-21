# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'questions/show', type: :view do
  before do
    @question = assign(:question, Question.create!(
                                    status: false,
                                    content: 'MyText'
                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
  end
end
