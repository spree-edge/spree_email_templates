module Spree
  module OrderMailerDecorator
    def cancel_email(order, email = nil)
      return unless template&.active?
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      email = email ? email : @order.email
      mail(to: email, from: from_address, subject: 'Cancellation of Order', body: @body, content_type: 'text/html')
    end

    def confirm_email(order, email = nil)
      return unless template&.active?
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      email = email ? email : @order.email
      mail(to: email, from: from_address, subject: 'Order Confirmation', body: @body, content_type: 'text/html')
    end

    def store_owner_notification_email(order, email = nil)
      return unless template&.active?
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      email = email ? email : current_store.new_order_notifications_email
      mail(to: email, from: from_address, subject: "#{current_store.name} received a new order", body: @body, content_type: 'text/html')
    end

    private

    def order_details
      @store = @order.store
      @user = @order.user
      @body = build_template(@order, @store, @user)
    end
  end
end
Spree::OrderMailer.prepend Spree::OrderMailerDecorator
