# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy upvote downvote]
  before_action :authenticate_user!
  impressionist actions: [:show], unique: [:impressionable_type, :impressionable_id, :ip_address]

  # GET /questions
  def index
    @questions = Question.all
  end

  # GET /questions/1
  def show; end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit; end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  # PATCH /questions/1/upvote
  def upvote
    if current_user.voted_up_for? @question
      @question.unvote_up current_user
    else
      @question.upvote_by current_user
      vote = 'upvote'
    end
    render 'questions/js/upvote', locals: { vote: vote }
  end

  # PATCH /questions/1/downvote
  def downvote
    if current_user.voted_down_for? @question
      @question.unvote_down current_user
    else
      @question.downvote_by current_user
      vote = 'downvote'
    end
    render 'questions/js/downvote', locals: { vote: vote }
  end

  # GET /questions/tagged/tag
  def tagged
    @questions = Question.filter_by_tag(params[:tag])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:status, :title, :body)
  end
end
