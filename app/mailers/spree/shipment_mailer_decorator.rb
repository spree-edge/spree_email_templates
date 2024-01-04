module Spree
  module ShipmentMailerDecorator
    def shipped_email(shipment, resend = false)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @order = @shipment.order
      email = id.present? ? email_to : @order.email
      mail(
        to: email,
        from: from_address,
        subject: 'Shipment Notification',
        body: @custom_body,
        content_type: 'text/html'
      )
    end
  end
end

Spree::ShipmentMailer.prepend Spree::ShipmentMailerDecorator
