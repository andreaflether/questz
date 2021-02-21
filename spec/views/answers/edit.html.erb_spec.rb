require 'rails_helper'

RSpec.describe "answers/edit", type: :view do
  before(:each) do
    @answer = assign(:answer, Answer.create!(
      chosen: false,
      content: "MyText"
    ))
  end

  it "renders the edit answer form" do
    render

    assert_select "form[action=?][method=?]", answer_path(@answer), "post" do

      assert_select "input[name=?]", "answer[chosen]"

      assert_select "textarea[name=?]", "answer[content]"
    end
  end
end
