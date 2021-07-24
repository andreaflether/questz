module Admin
  class QuestionsController < AdminController
    def index
      @query = Question.ransack(params[:query])
      @questions = @query.result
                     .page(params[:page])
                     .includes([:user])
    end
  
    def edit
    end
  
    def update
    end
  
    def destroy
    end
  
    def toggle_status
    end
  end
end
