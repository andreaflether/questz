# frozen_string_literal: true

module Admin
  class TagsController < AdminController
    before_action :set_tag, only: %i[destroy]

    # GET /admin/tags
    def index
      @tags = Tag.order(:name)
                 .page(params[:page])
                 .per(20)
    end

    # DELETE /admin/tags/1
    def destroy
      @tag.destroy
      redirect_to admin_tags_path, notice: I18n.t('controllers.tags.destroy')
    end

    private

    def set_tag
      @tag = Tag.find_by(name: params[:name])
    end
  end
end
