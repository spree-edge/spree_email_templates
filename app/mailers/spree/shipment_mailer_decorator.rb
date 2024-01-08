module Spree
  module ShipmentMailerDecorator
    def shipped_email(shipment, resend = false)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @order = @shipment.order
      email = @order.email
      shipment_details
      mail(to: email, from: from_address, subject: 'Shipment Notification', body: @body, content_type: 'text/html')
    end

    private

    def shipment_details
      line_item_details = render_to_string(partial: 'spree/shared/purchased_items_table',
                                           locals: {
                                             line_items: @shipment.manifest.map(&:line_item), order: @shipment.order
                                           })
      line_items_table = render_to_string(collection: @shipment.order.line_items,
                                          partial: 'spree/shared/purchased_items_table/line_item', as: :line_item)
      @body = build_template(@shipment, { line_item_details: line_item_details, line_items_table: line_items_table })
    end
  end
end

Spree::ShipmentMailer.prepend Spree::ShipmentMailerDecorator
