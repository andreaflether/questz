# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy upvote downvote]
  before_action :authenticate_user!, except: %i[index show upvote downvote search]
  before_action :authenticate_remote!, only: %i[upvote downvote]
  impressionist actions: [:show], unique: %i[impressionable_type impressionable_id ip_address]
  load_and_authorize_resource except: %i[search], find_by: :slug

  # GET /questions
  def index
    @questions = Question.most_voted
    sanitize_filter_params if params[:tab]
    get_questions_and_top_users
  end

  def feed
    if user_signed_in? && current_user.follow_count.positive?
      @questions = Question.with_user_followed_tags(current_user)
      @tags = current_user.all_following.sort_by(&:name)
    else
      @questions = Question.most_voted
    end

    sanitize_filter_params if params[:tab]
    get_questions_and_top_users
  end

  def search
    @questions = if params[:search]
                   Question.where('lower(title) LIKE lower(:search) OR id LIKE :search',
                                  search: "%#{params[:search]}%")
                 else
                   Question.all
                 end
    @questions = @questions.page(params[:page])
  end

  # GET /questions/1
  def show
    @related_questions = @question.find_related_tags
                                  .limit(8)
    @answers = @question.answers
                        .page(params[:page])
    @is_answered = @question.answered?
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
      redirect_to @question, notice: I18n.t('controllers.questions.create')
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: I18n.t('controllers.questions.update')
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: I18n.t('controllers.questions.destroy')
  end

  # PATCH /questions/1/upvote
  def upvote
    if current_user.voted_up_for? @question
      @question.unvote_up current_user
      @question.create_activity(key: 'question.unvote_up', owner: @question.user)
      @question.user.add_points(
        t('honor.exp.question.unvote_up'), t('honor.message.question.unvote_up'), 'question.unvote_up'
      )
    else
      @question.upvote_by current_user
      @question.create_activity(key: 'question.upvote', owner: @question.user)
      @question.user.subtract_points(
        t('honor.exp.question.upvote').abs, t('honor.message.question.upvote'), 'question.upvote'
      )
      vote = 'upvote'
    end
    render 'shared/js/vote', locals: { vote: vote, type: 'question', object: @question }
  end

  # PATCH /questions/1/downvote
  def downvote
    if current_user.voted_down_for? @question
      @question.unvote_down current_user
      @question.create_activity(key: 'question.unvote_down', owner: @question.user)
      @question.user.add_points(
        t('honor.exp.question.unvote_down'), t('honor.message.question.unvote_down'), 'question.unvote_down'
      )
    else
      @question.downvote_by current_user
      @question.create_activity(key: 'question.downvote', owner: @question.user)
      @question.user.subtract_points(
        t('honor.exp.question.downvote').abs, t('honor.message.question.downvote'), 'question.downvote'
      )
      vote = 'downvote'
    end
    render 'shared/js/vote', locals: { vote: vote, type: 'question', object: @question }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find_by(slug: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:status, :title, :body, :reopen, tag_list: [], answers: [])
  end

  def get_questions_and_top_users
    @questions = @questions
                 .includes(%i[tags user tag_taggings])
                 .page(params[:page])
    @top_users = User.top_users.limit(3)
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
