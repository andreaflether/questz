# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user
    before_action :set_resource, only: %i[strike create_strike]

    def index
      @query = User.ransack(params[:query])
      @users = @query.result.page(params[:page])
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to(admin_users_path, notice: I18n.t('controllers.users.update'))
      else
        render :edit
      end
    end

    def strike
      @notice = Notice.new(noticeable_type: params[:resource_type], user: @user)
    end

    def create_strike
      @notice = Notice.new(notice_params)
      @notice.assign_attributes(user: @user, given_by_id: current_user.id)

      if @notice.save
        redirect_to admin_questions_path, notice: I18n.t('controllers.notices.create')
      else
        render :strike
      end
    end

    private

    def set_user
      @user = User.find_by(username: params[:username])
    end

    def set_resource
      @resource = if params[:noticeable_type] == 'Answer'
                    Answer.find(params[:noticeable_id])
                  else
                    Question.find(params[:noticeable_id])
                  end
    end

    def user_params
      params.require(:user).permit(:name, :username, :email, :role)
    end

    def notice_params
      params.require(:notice).permit(:noticeable_type, :noticeable_id, :details, :reason)
    end
  end
end
