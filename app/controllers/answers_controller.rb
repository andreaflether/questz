# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy choose upvote downvote]
  before_action :set_question, only: %i[new create update edit]
  before_action :authenticate_user!, except: %i[upvote downvote]
  before_action :authenticate_remote!, only: %i[upvote downvote]
  load_and_authorize_resource

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
    @answer.user = current_user
    @answer.question = @question
    
    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully posted!'
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
    @answer.chosen = true

    if @answer.save
      redirect_to @answer.question, notice: 'Your question is now answered!'
    else
      redirect_to @answer.question, error: @answer.errors.full_messages.first
    end
  end

  # PATCH /answers/1/downvote
  def upvote
    if current_user.voted_up_for? @answer
      @answer.unvote_up current_user
      @answer.create_activity(key: 'answer.unvote_up', owner: @answer.user)
      @answer.user.subtract_points(t('honor.exp.answer.unvote_up').abs, category: 'answer.unvote_up')
    else
      @answer.upvote_by current_user
      @answer.create_activity(key: 'answer.upvote', owner: @answer.user)
      @answer.user.add_points(t('honor.exp.answer.upvote'), category: 'answer.upvote')
      vote = 'upvote'
    end
    render 'shared/js/vote', locals: { vote: vote, type: 'answer', object: @answer }
  end

  # PATCH /answers/1/downvote
  def downvote
    if current_user.voted_down_for? @answer
      @answer.unvote_down current_user
      @answer.create_activity(key: 'answer.unvote_down', owner: @answer.user)
      @answer.user.add_points(
        t('honor.exp.answer.unvote_down'), t('honor.message.answer.unvote_down'), 'answer.unvote_down'
      )
    else
      @answer.downvote_by current_user
      @answer.create_activity(key: 'answer.downvote', owner: @answer.user)
      @answer.user.subtract_points(
        t('honor.exp.answer.downvote').abs, t('honor.message.answer.downvote'), 'answer.downvote'
      )
      vote = 'downvote'
    end
    render 'shared/js/vote', locals: { vote: vote, type: 'answer', object: @answer }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  # Only allow a list of trusted parameters through.
  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
