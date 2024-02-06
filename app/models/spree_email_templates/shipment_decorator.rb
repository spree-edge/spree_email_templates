module SpreeEmailTemplates
  module ShipmentDecorator

    def custom_fields
      {
        'shipping_method_name' => shipping_method.name
      }
    end

  end
end

::Spree::Shipment.prepend ::SpreeEmailTemplates::ShipmentDecorator
