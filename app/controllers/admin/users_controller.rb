module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[edit update destroy]

    def index
      @query = User.ransack(params[:query])
      @users = @query.result
                     .page(params[:page])
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to(admin_users_path, notice: I18n.t('controllers.users.update'))
      else
        render :edit
      end
    end

    private

    def set_user
      @user = User.find_by(username: params[:username])
    end

    def user_params
      params.require(:user).permit(:name, :username, :email, :role)
    end
  end
end