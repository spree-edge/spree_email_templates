module Spree
  module BaseMailerDecorator

    private

    def build_template(order, store, user, reimbursement = nil, shipment = nil)

      return unless template(user).present?

      @body = template(user).render_body(order, store, user, reimbursement, shipment)
    end

    def template(user)
      locale = user.selected_locale || current_store.default_locale

      current_store.templates.find_by(name: action_name, locale: locale) ||
      current_store.templates.find_by(name: action_name, locale: 'en')
    end

  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
