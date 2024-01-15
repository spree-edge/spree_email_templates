module Spree
  module Admin
    class TemplatesController < Spree::Admin::BaseController
      before_action :find_template, only: [:edit, :update]

      def index
        @templates = current_store.templates

        unless @templates
          flash[:alert] = Spree.t(:not_found, scope: :template)
        end
      end

      def update
        @content_json = JSON.parse(params[:content_json]) if params[:content_json].present?

        if permitted_params[:active]
          active = permitted_params[:active] == 'false' ? false : true
          @template.update(active: active)
        else
          @template.update(permitted_params)
        end

        flash[:success] = Spree.t(:updated, scope: :template)
      end

      private

      def find_template
        @template = Template.find_by(id: params[:id])

        unless @template
          redirect_to admin_templates_path
          flash[:alert] = Spree.t(:not_found, scope: :template)
        end
      end

      def permitted_params
        params.permit(:content_html, :active, :id).merge(content_json: @content_json)
      end
    end
  end
end
