module Admin
  class QuestionsController < AdminController
    before_action :set_question, except: %i[index]
    
    # GET /admin/questions
    def index
      @query = Question.ransack(params[:query])
      @questions = @query.result
                     .page(params[:page])
                     .includes([:user])
    end

    # GET /admin/questions/1
    def show; end
    
    # GET /admin/questions/1/edit
    def edit; end
    
    # PATCH/PUT /admin/questions/1
    def update; end
    
    # DELETE /admin/questions/1
    def destroy
      @question.destroy
      # redirect_to admin_questions_path, notice: I18n.t('controllers.questions.destroy')
      redirect_to admin_questions_path, notice: @question.errors.full_messages.first
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
      @question = Question.find_by(slug: params[:id] || params[:question_id])
    end

    def question_params
      params.require(:question).permit(:title, :body, :status, :closing_notice)
    end
  end
end
