module Spree
  module ReimbursementMailerDecorator
    def reimbursement_email(reimbursement, resend = false)
      @reimbursement = reimbursement.respond_to?(:id) ? reimbursement : Spree::Reimbursement.find(reimbursement)
      @order = @reimbursement.order
      email = @order.email
      reimbursement_details
      mail(to: email, from: from_address, subject: 'Reimbursement Order email', body: @body, content_type: 'text/html')
    end

    private

    def reimbursement_details
      reimbursement_item_details = render_to_string(partial: 'spree/reimbursement_mailer/shared/reimbursement_table',
                                                    locals: { reimbursement: @reimbursement })
      @body = build_template(@reimbursement, { reimbursement_item_details: reimbursement_item_details })
    end
  end
end
Spree::ReimbursementMailer.prepend Spree::ReimbursementMailerDecorator
