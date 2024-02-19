module Spree
  module ShipmentMailerDecorator
    def shipped_email(shipment, email = nil, id = nil)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @order = @shipment.order
      @user = @order.user
      return unless template(@user, id)&.active?

      email = email ? email : @order.email
      shipment_details(id)
      mail(to: email, from: from_address, subject: 'Shipment Notification', body: @body, content_type: 'text/html')
    end

    private

    def shipment_details(id)
      @store = @shipment.store
      @body = build_template(@order, @store, @user, reimbursement = nil, @shipment, id)
    end
  end
end

Spree::ShipmentMailer.prepend Spree::ShipmentMailerDecorator
