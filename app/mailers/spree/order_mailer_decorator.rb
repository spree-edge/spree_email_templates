# need to remove content_type: 'text/html' line while done all things
module Spree
  module OrderMailerDecorator
    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      mail(to: @order.email, from: from_address, subject: 'Cancellation of Order', body: @body, content_type: 'text/html')
    end

    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      mail(to: @order.email, from: from_address, subject: 'Order Confirmation', body: @body, content_type: 'text/html')
    end

    def store_owner_notification_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
      order_details
      mail(to: @order.email, from: from_address, subject: "#{current_store.name} received a new order", body: @body, content_type: 'text/html')
    end

    private

    def order_details
      line_item_details = render_to_string(partial: 'spree/shared/purchased_items_table',
                                           locals: {
                                             line_items: @order.line_items, order: @order
                                           })
      line_items_table = render_to_string(collection: @order.line_items,
                                          partial: 'spree/shared/purchased_items_table/line_item', as: :line_item)
      @body = build_template(@order, { line_item_details: line_item_details, line_items_table: line_items_table })
    end
  end
end
Spree::OrderMailer.prepend Spree::OrderMailerDecorator
