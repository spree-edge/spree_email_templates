class Template < ApplicationRecord
  require 'liquid'
  belongs_to :store, class_name: '::Spree::Store'

  def render_body(resource, options)
    @resource = resource
    @options = options
    template = ::Liquid::Template.parse(content_html)
    template_variables = send(name.to_s)
    template.render(template_variables)
  end

  private

  def confirm_email
    order_vaiables
  end

  def cancel_email
    order_vaiables
  end

  def store_owner_notification_email
    order_vaiables
  end

  def reimbursement_email
    reimbursement_email_variables
  end

  def shipped_email
    shipment_variables
  end

  def order_vaiables
    {
      'username' => @resource.name,
      'user_email' => @resource.email,
      'order_number' => @resource.number,
      'order_total' => @resource.total,
      'line_item_details' => @options[:line_item_details],
      'tax' => @resource.additional_tax_total,
      'subtotal' => @resource.item_total,
      'store_name' => @resource.store.name,
      'line_items_table' => @options[:line_items_table]
    }
  end

  def shipment_variables
    { 'username' => @resource.order.name,
      'user_email' => @resource.order.email,
      'order_number' => @resource.order.number,
      'shipping_method_name' => @resource.shipping_method.name,
      'store_name' => @resource.store.name,
      'tracking_url' => @resource.tracking_url,
      'track_information' => @resource.tracking,
      'order_total' => @resource.order.total,
      'line_item_details' => @options[:line_item_details],
      'tax' => @resource.order.additional_tax_total,
      'subtotal' => @resource.order.item_total,
      'store_name' => @resource.store.name,
      'line_items_table' => @options[:line_items_table] }
  end

  def reimbursement_email_variables
    { 'username' => @resource.order.name,
      'user_email' => @resource.order.email,
      'order_number' => @resource.order.number,
      'store_name' => @resource.order.store.name,
      'reimbursement_item_details' => @options[:reimbursement_item_details],
      'reimbursement_total' => @resource.total }
  end
end
