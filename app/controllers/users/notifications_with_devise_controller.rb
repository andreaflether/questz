# frozen_string_literal: true

module Users
  class NotificationsWithDeviseController < ActivityNotification::NotificationsWithDeviseController
    # GET /:target_type/:target_id/notifications
    def index
      super
      paginate_array = Kaminari.paginate_array(@notifications)

      @notifications = paginate_array.page(params[:page])
                                     .per(10)
    end

    # POST /:target_type/:target_id/notifications/open_all
    # def open_all
    #   super
    # end

    # GET /:target_type/:target_id/notifications/:id
    # def show
    #   super
    # end

    # DELETE /:target_type/:target_id/notifications/:id
    # def destroy
    #   super
    # end

    # PUT /:target_type/:target_id/notifications/:id/open
    # def open
    #   super
    # end

    # GET /:target_type/:target_id/notifications/:id/move
    # def move
    #   super
    # end
  end
end
