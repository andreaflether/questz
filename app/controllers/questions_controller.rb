# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy upvote downvote]
  before_action :authenticate_user!, except: %i[index show]
  impressionist actions: [:show], unique: %i[impressionable_type impressionable_id ip_address]
  load_and_authorize_resource

  # GET /questions
  def index
    @questions = Question.most_voted
    sanitize_filter_params if params[:tab]
    get_questions_and_top_users
  end
  
  def feed 
    if user_signed_in? && current_user.follow_count > 1
      @questions = Question.with_user_followed_tags(current_user)
      @tags = current_user.all_following
    else
      @questions = Question.most_voted
    end
    
    sanitize_filter_params if params[:tab]
    get_questions_and_top_users
  end
  
  # GET /questions/1
  def show
    @related_questions = @question.find_related_tags.limit(8)
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit; end

  # POST /questions
  def create
    @question = Question.new(question_params)
    @question.user = current_user

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
    render 'shared/js/upvote', locals: { vote: vote, resource: 'question' }
  end

  # PATCH /questions/1/downvote
  def downvote
    if current_user.voted_down_for? @question
      @question.unvote_down current_user
    else
      @question.downvote_by current_user
      vote = 'downvote'
    end
    render 'shared/js/downvote', locals: { vote: vote, resource: 'question' }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:status, :title, :body, tag_list: [])
  end

  def get_questions_and_top_users
    @questions = @questions
                 .includes(%i[tags user tag_taggings])
                 .page(params[:page])
    @top_users = User.top_users
  end


  def sanitize_filter_params
    if %w[answered unanswered newest].include?(params[:tab])
      @questions_to_exihibt = @questions.public_send(params[:tab])
      @questions_tagged_with = @questions_to_exihibt.tagged_with(params[:tag]) if params[:tag]
      @questions = @questions_tagged_with ||= @questions_to_exihibt
    else
      @message = "<b>#{params[:tab]}</b> is not a valid filter."
    end
  end
end
