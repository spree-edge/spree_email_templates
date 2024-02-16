class Template < ApplicationRecord
  require 'liquid'

  gem_path = Gem::Specification.find_by_name('spree_email_templates').gem_dir
  return_item = File.join(gem_path, 'app', 'models', 'spree', 'return_item.rb')
  require return_item

  belongs_to :store, class_name: '::Spree::Store'

  def render_body(order, store, user, reimbursement, shipment)
    template = ::Liquid::Template.parse(content_html)
    template_variables = merge_parsed_attrubutes(order, store, user, reimbursement, shipment)
                                 .merge(parsed_associate_attributes(order, reimbursement, shipment))
    template.render(template_variables)
  end

  def send_mail(email, mailer_class)
    mailer_class.constantize.send(name, record(mailer_class), email).deliver_now
  end

  def tags
    keys(objects)
  end

  private

  def merge_parsed_attrubutes(*resources)
    resources.each_with_object({}) do |resource, merged_hash|
      output = parsed_attributes(resource) if resource
      resource.class.name == 'Spree::Shipment' ? output["shipment"].merge!(resource.custom_fields) : output
      merged_hash.merge!(output) if output
    end
  end

  def parsed_attributes(resource)
    { "#{resource.class.name.demodulize.downcase}" => resource&.attributes&.transform_keys { |key| "#{key}" } || {} }
  end

  def parsed_associate_attributes(order, reimbursement, shipment)
    associated_attrubutes.each_with_object({}) do |tag, result|
      if reimbursement
        result['exchange_items'] = reimbursement.send(tag).exchange_requested.map do |associated_object|
          variant = associated_object.variant
          {'variant_name' => variant.name, 'variant_option_text' => variant.options_text}
        end
      else
        object = shipment ? shipment : order
        result[tag.to_s] = object.send(tag).map do |associated_object|
          associated_object.attributes.merge(associated_object.custom_fields)
        end
      end
    end
  end

  def keys(objects)
    objects.flat_map do |object|
      if object == 'Spree::LineItem' || object == 'Spree::Shipment'
        tag = custom_tags(object)
        object = object.constantize
        keys = object.attribute_names.map { |name| "#{object.name.demodulize.downcase}.#{name}" } + tag
        keys - excluded_keys(object)
      elsif object == 'exchange_items'
        keys = custom_tags(object)
      else
        keys = object.attribute_names.map { |name| "#{object.name.demodulize.downcase}.#{name}" }
        keys - excluded_keys(object)
      end
    end
  end

  def excluded_keys(object)
    case object.to_s
    when 'Spree::Order'
      ['order.user_id', 'order.completed_at', 'order.bill_address_id', 'order.ship_address_id', 'order.created_at', 'order.updated_at',
        'order.last_ip_address', 'order.created_by_id', 'order.channel', 'order.approver_id', 'order.approved_at',
        'order.confirmation_delivered', 'order.considered_risky', 'order.token', 'order.canceled_at', 'order.canceler_id', 'order.store_id',
        'order.state_lock_version', 'order.store_owner_notification_delivered', 'order.public_metadata', 'order.private_metadata',
        'order.gift_card_notified', 'order.preferences', 'order.state_machine_resumed', 'order.id', 'order.state', 'order.shipment_state',
        'order.payment_state', 'order.included_tax_total', 'order.item_count'
      ]
      when 'Spree::Store'
        ['store.meta_description', 'store.meta_keywords', 'store.seo_title', 'store.code', 'store.default', 'store.created_at',
         'store.updated_at', 'store.supported_currencies', 'store.default_locale', 'store.default_country_id',
         'store.new_order_notifications_email', 'store.checkout_zone_id', 'store.seo_robots', 'store.supported_locales',
         'store.deleted_at', 'tore.settings', 'store.preferences', 'store.mail_from_address', 'store.default_currency', 'store.id'
        ]
      when 'Spree::User'
        ['user.encrypted_password', 'user.password_salt', 'user.remember_token', 'user.persistence_token', 'user.reset_password_token',
        'user.perishable_token', 'user.sign_in_count', 'user.failed_attempts', 'user.last_request_at', 'user.current_sign_in_at',
        'user.last_sign_in_at', 'user.current_sign_in_ip', 'user.last_sign_in_ip', 'user.ship_address_id', 'user.bill_address_id',
        'user.authentication_token', 'user.unlock_token', 'user.locked_at', 'user.reset_password_sent_at', 'user.created_at',
        'user.updated_at', 'user.public_metadata', 'user.private_metadata', 'user.spree_api_key', 'user.remember_created_at',
        'user.deleted_at', 'user.confirmation_token', 'user.confirmed_at', 'user.confirmation_sent_at', 'user.selected_locale',
        'user.preferences', 'user.id', 'user.login'
        ]
      when 'Spree::LineItem'
        ['lineitem.variant_id', 'lineitem.order_id', 'lineitem.created_at', 'lineitem.updated_at', 'lineitem.tax_category_id',
         'lineitem.public_metadata', 'lineitem.private_metadata', 'lineitem.preferences', 'lineitem.id', 'lineitem.cost_price',
         'lineitem.additional_tax_total', 'lineitem.included_tax_total', 'lineitem.pre_tax_amount'
        ]
      when 'Spree::Shipment'
        ['shipment.shipped_at', 'shipment.order_id', 'shipment.address_id', 'shipment.created_at', 'shipment.updated_at',
         'shipment.stock_location_id', 'shipment.public_metadata', 'shipment.private_metadata', 'shipment.scan_form_id',
         'shipment.preferences', 'shipment.id', 'shipment.state', 'shipment.additional_tax_total', 'shipment.included_tax_total',
         'shipment.pre_tax_amount'
        ]
      when 'Spree::Reimbursement'
        ['reimbursement.customer_return_id', 'reimbursement.order_id', 'reimbursement.created_at', 'reimbursement.updated_at',
        'reimbursement.preferences', 'reimbursement.id', 'reimbursement.reimbursement_status'
        ]
    end
  end

  def custom_tags(object)
    if object == 'Spree::LineItem'
      ['lineitem.single_money', 'lineitem.display_amount',
       'lineitem.options_text', 'lineitem.name']
    elsif object == 'Spree::Shipment'
      ['shipment.shipping_method_name']
    elsif object == 'exchange_items'
      ['exchangeitem.variant_name', 'exchangeitem.variant_option_text']
    end
  end

  def objects
    case name
    when 'confirm_email', 'cancel_email', 'store_owner_notification_email'
      [Spree::Order, Spree::Store, Spree::User, 'Spree::LineItem', 'Spree::Shipment']
    when 'shipped_email'
      [Spree::Order, Spree::Store, Spree::User, Spree::Shipment, 'Spree::LineItem']
    when 'reimbursement_email'
      [Spree::Order, Spree::Store, Spree::User, Spree::Reimbursement, 'exchange_items']
    end
  end

  def associated_attrubutes
    case name
    when 'confirm_email', 'cancel_email', 'store_owner_notification_email'
      [:line_items, :shipments]
    when 'shipped_email'
      [:line_items]
    when 'reimbursement_email'
      [:return_items]
    end
  end

  def record(mailer_class)
    case mailer_class
    when 'Spree::OrderMailer'
      Spree::Order.last
    when 'Spree::ShipmentMailer'
      Spree::Shipment.last
    when 'Spree::ReimbursementMailer'
      Spree::Reimbursement.last
    end
  end
end
