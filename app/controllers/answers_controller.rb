# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy choose upvote downvote]
  before_action :authenticate_user!, only: %i[edit choose upvote downvote]

  # GET /answers
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  def show; end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit; end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to @answer, notice: 'Answer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      redirect_to @answer, notice: 'Answer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy
    redirect_to answers_url, notice: 'Answer was successfully destroyed.'
  end

  # PATCH /answers/1/choose
  def choose
    @answer.chosen

    if @answer.save
      redirect_to @answer.question, notice: 'Your question is now answered!'
    else
      redirect_to @answer.question, error: 'Se lascou kkk'
    end
  end

  # PATCH /answers/1/downvote
  def upvote
    if current_user.voted_up_for? @answer
      @answer.unvote_up current_user
    else
      @answer.upvote_by current_user
      vote = 'upvote'
    end
    render 'shared/js/upvote', locals: { vote: vote, resource: 'answer' }
  end

  # PATCH /answers/1/downvote
  def downvote
    if current_user.voted_down_for? @answer
      @answer.unvote_down current_user
    else
      @answer.downvote_by current_user
      vote = 'downvote'
    end
    render 'shared/js/downvote', locals: { vote: vote, resource: 'answer' }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_answer
    @answer = Answer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def answer_params
    params.require(:answer).permit(:chosen, :body)
  end
end
