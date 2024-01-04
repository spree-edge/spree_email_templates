module Spree
  module ReturnAuthorizationMailer
    def return_authorization_email(return_authorization, resend = false)
      @return_authorization = return_authorization.respond_to?(:id) ? return_authorization : Spree::ReturnAuthorization.find(return_authorization)
      @order = @return_authorization.order
      email = id.present? ? email_to : @order.email
      mail(
        to: email,
        from: from_address,
        subject: 'Return Authorization of Order',
        body: @custom_body,
        content_type: 'text/html'
      )
    end
  end
end
