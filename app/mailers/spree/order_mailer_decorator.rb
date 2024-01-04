# need to remove content_type: 'text/html' line while done all things
module Spree
  module OrderMailerDecorator
    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      mail(
        to: @order.email,
        from: from_address,
        subject: 'Cancellation of Order',
        body: @custom_body,
        content_type: 'text/html'
      )
    end

    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      mail(
        to: @order.email,
        from: from_address,
        subject: 'Order Confirmation',
        body: @custom_body,
        content_type: 'text/html'
      )
    end

    def store_owner_notification_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      mail(
        to: @order.email,
        from: from_address,
        subject: "#{current_store.name} received a new order",
        body: @custom_body,
        content_type: 'text/html'
      )
    end
  end
end
Spree::OrderMailer.prepend Spree::OrderMailerDecorator
