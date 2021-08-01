# frozen_string_literal: true

module Admin
  class QuestionsController < AdminController
    before_action :set_question, except: %i[index]
    load_and_authorize_resource find_by: :slug

    # GET /admin/questions
    def index
      @query = Question.ransack(params[:query])
      @questions = @query.result
                         .page(params[:page])
                         .includes([:user])
    end

    # GET /admin/questions/1
    def show
      @answers = @question.answers.includes([:user])
      @filters = LanguageFilter::Filter.new(
        matchlist: File.join(Rails.root, '/config/language_filters/custom_list.yml')
      )
      filter_answers
    end

    # GET /admin/questions/1/edit
    def edit; end

    # PATCH/PUT /admin/questions/1
    def update
      if @question.update(question_params)
        redirect_to([:admin, @question], notice: I18n.t('controllers.questions.update'))
      else
        render :edit
      end
    end

    # DELETE /admin/questions/1
    def destroy
      @question.destroy
      redirect_to admin_questions_path, notice: I18n.t('controllers.questions.destroy')
    end

    # PATCH /admin/questions/1/close
    def close
      if @question.update(question_params)
        redirect_to request.referer, notice: I18n.t('controllers.questions.close')
      else
        redirect_to request.referer, flash: { error: @question.errors.full_messages.first }
      end
    end

    # PATCH /admin/questions/1/reopen
    def reopen
      @question.update(reopen: true)
      redirect_to request.referer, notice: I18n.t('controllers.questions.reopen')
    end

    # GET /admin/questions/1/close_modal
    def close_modal; end

    private

    def set_question
      @question = Question.find_by(slug: params[:slug])
    end

    def question_params
      params.require(:question).permit(:title, :body, :status, :closing_notice, :duplicate_id, tag_list: [])
    end

    def filter_answers
      @answers.each { |a| helpers.get_filtered_content(a) }
    end
  end
end
