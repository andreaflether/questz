# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'answers/show', type: :view do
  before do
    @answer = assign(:answer, Answer.create!(
                                chosen: false,
                                content: 'MyText'
                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
  end
end