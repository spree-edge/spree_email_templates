module Spree
  module ReimbursementMailerDecorator
    def reimbursement_email(reimbursement, email = nil)
      return unless template&.active?
      @reimbursement = reimbursement.respond_to?(:id) ? reimbursement.reload : ::Spree::Reimbursement.find(reimbursement)
      @order = @reimbursement.order
      email = email ? email : @order.email
      reimbursement_details
      mail(to: email, from: from_address, subject: 'Reimbursement Order email', body: @body, content_type: 'text/html')
    end

    private

    def reimbursement_details
      @store = @reimbursement.order
      @user = @order.user
      @body = build_template(@order, @store, @user, @reimbursement)
    end
  end
end
Spree::ReimbursementMailer.prepend Spree::ReimbursementMailerDecorator
