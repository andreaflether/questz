module Admin
  class AnswersController < AdminController
    before_action :set_answer
    load_and_authorize_resource find_by: :slug

    # DELETE /admin/answers/1
    def destroy
      @answer.destroy
      redirect_to([:admin, @answer.question], notice: I18n.t('controllers.questions.destroy'))
    end

    private

    def set_answer
      @answer = Answer.find(params[:id])
    end
  end
end