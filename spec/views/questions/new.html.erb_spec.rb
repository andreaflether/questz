# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'questions/new', type: :view do
  before do
    assign(:question, Question.new(
                        status: false,
                        content: 'MyText'
                      ))
  end

  it 'renders new question form' do
    render

    assert_select 'form[action=?][method=?]', questions_path, 'post' do
      assert_select 'input[name=?]', 'question[status]'

      assert_select 'textarea[name=?]', 'question[content]'
    end
  end
end
