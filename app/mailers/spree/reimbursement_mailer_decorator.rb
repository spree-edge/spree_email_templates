module Spree
  module ReimbursementMailerDecorator
    def reimbursement_email(reimbursement, resend = false)
      @reimbursement = reimbursement.respond_to?(:id) ? reimbursement : Spree::Reimbursement.find(reimbursement)
      @order = @reimbursement.order
      email = id.present? ? email_to : @order.email
      mail(
        to: email,
        from: from_address,
        subject: 'Reimbursement Order email',
        body: @custom_body,
        content_type: 'text/html'
      )
    end
  end
end

Spree::ReimbursementMailer.prepend Spree::ReimbursementMailerDecorator
