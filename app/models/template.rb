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
      parse_data = resource.class.name == 'Spree::Shipment' ? output.merge(resource.custom_fields) : output
      merged_hash.merge!(parse_data) if parse_data
    end
  end

  def parsed_attributes(resource)
    resource&.attributes&.transform_keys { |key| "#{resource.class.name.demodulize.downcase}_#{key}" } || {}
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
        object.attribute_names.map { |name| "#{object.name.demodulize.downcase}.#{name}" } + tag
      elsif object == 'exchange_items'
        tag = custom_tags(object)
      else
        object.attribute_names.map { |name| "#{object.name.demodulize.downcase}_#{name}" }
      end
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
