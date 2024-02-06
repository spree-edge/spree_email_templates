module Spree
  module ShipmentMailerDecorator
    def shipped_email(shipment, email = nil)
      return unless template&.active?
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @order = @shipment.order
      email = email ? email : @order.email
      shipment_details
      mail(to: email, from: from_address, subject: 'Shipment Notification', body: @body, content_type: 'text/html')
    end

    private

    def shipment_details
      @store = @shipment.store
      @user = @order.user
      @body = build_template(@order, @store, @user, reimbursement = nil, @shipment)
    end
  end
end

Spree::ShipmentMailer.prepend Spree::ShipmentMailerDecorator
