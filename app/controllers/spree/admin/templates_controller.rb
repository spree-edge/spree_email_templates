module Spree
  module Admin
    class TemplatesController < Spree::Admin::BaseController
      before_action :find_template, only: [:edit, :update, :test_email, :clone]

      def index
        @templates = current_store.templates

        unless @templates
          flash[:alert] = Spree.t(:not_found, scope: :template)
        end
      end

      def edit
        tags = @template.tags
        @tags_with_description = tags.map { |tag| [tag, Spree.t(tag)] }.to_h
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

      def test_email
        email = permitted_params[:email]
        if email && @template.active
          @template.send_mail(email, mailer_class)
          redirect_to admin_templates_path
          flash[:success] = Spree.t(:test_mail_sent, scope: :template)
        else
          redirect_to admin_templates_path
          flash[:alert] = Spree.t(:active_template, scope: :template)
        end
      end

      def clone
        @cloned_template = @template.dup
        if @cloned_template.save
          redirect_to admin_templates_path
          flash[:success] = Spree.t(:template_cloned, scope: :template)
        else
          redirect_to admin_templates_path
          flash[:alert] = Spree.t(:clone_failed, scope: :template)
        end
      end

      private

      def find_template
        @template = Template.find_by(id: params[:id])

        unless @template
          redirect_to admin_templates_path
          flash[:alert] = Spree.t(:not_found, scope: :template)
        end
      end

      def mailer_class
        case @template.name
        when 'confirm_email', 'cancel_email', 'store_owner_notification_email'
          'Spree::OrderMailer'
        when 'shipped_email'
          'Spree::ShipmentMailer'
        when 'reimbursement_email'
          'Spree::ReimbursementMailer'
        end
      end

      def permitted_params
        params.permit(:content_html, :active, :id, :email, :locale).merge(content_json: @content_json)
      end
    end
  end
end
