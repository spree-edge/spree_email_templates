module Spree
  module Admin
    class EmailTemplatesController < BaseController
      before_action :set_store, only: [:edit, :update]

      def edit; end

      def update
        if @store.update(store_params)
          flash[:success] = Spree.t(:unlayer_project_id_updated)
          redirect_to edit_admin_store_email_templates_path(@store)
        else
          flash[:alert] = Spree.t(:unlayer_project_id_failed)
          render :edit
        end
      end

      private

      def set_store
        @store = Spree::Store.find(params[:store_id])
      end

      def store_params
        params.require(:store).permit(:unlayer_project_id)
      end
    end
  end
end
