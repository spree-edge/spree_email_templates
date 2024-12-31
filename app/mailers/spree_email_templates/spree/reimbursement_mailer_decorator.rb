module SpreeEmailTemplates
  module Spree
    module ReimbursementMailerDecorator
      def reimbursement_email(reimbursement, email = nil, id = nil)
        @reimbursement = reimbursement.respond_to?(:id) ? reimbursement.reload : ::Spree::Reimbursement.find(reimbursement)
        @order = @reimbursement.order
        @user = @order.user
        return unless template(@user, id)&.active?

        email = email ? email : @order.email
        reimbursement_details(id)
        mail(to: email, from: from_address, subject: 'Reimbursement Order email', body: @body, content_type: 'text/html')
      end

      private

      def reimbursement_details(id)
        @store = @reimbursement.order
        @body = build_template(@order, @store, @user, @reimbursement, @shipment = nil, id)
      end
    end
  end
end

::Spree::ReimbursementMailer.prepend ::SpreeEmailTemplates::Spree::ReimbursementMailerDecorator
