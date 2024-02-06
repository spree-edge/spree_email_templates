module Spree
  module BaseMailerDecorator

    private

    def build_template(order, store, user, reimbursement = nil, shipment = nil)

      return unless template.present?

      @body = template.render_body(order, store, user, reimbursement, shipment)
    end

    def template
      current_store.templates.find_by(name: action_name)
    end

  end
end

::Spree::BaseMailer.prepend ::Spree::BaseMailerDecorator
