# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'questions/index', type: :view do
  before do
    assign(:questions, [
             Question.create!(
               status: false,
               content: 'MyText'
             ),
             Question.create!(
               status: false,
               content: 'MyText'
             )
           ])
  end

  it 'renders a list of questions' do
    render
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
