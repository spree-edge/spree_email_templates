module SpreeEmailTemplates
  module Spree
    module BaseMailerDecorator

      private

      def build_template(order, store, user, reimbursement = nil, shipment = nil, id)

        return unless template(user, id).present?

        @body = template(user, id).render_body(order, store, user, reimbursement, shipment)
      end

      def template(user, id = nil)
        if id.present?
          current_store.templates.find(id)
        else
          locale = current_store.default_locale || user.selected_locale

          current_store.templates.find_by(name: action_name, locale: locale) ||
          current_store.templates.find_by(name: action_name, locale: 'en')
        end
      end

    end
  end
end

::Spree::BaseMailer.prepend ::SpreeEmailTemplates::Spree::BaseMailerDecorator
